/*
 * [The "BSD license"]
 *  Copyright (c) 2012-2016 Marcel Schaible
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. The name of the author may not be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package org.smallpearl.compiler;

import org.antlr.v4.runtime.*;
import org.stringtemplate.v4.*;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.io.PrintWriter;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Collections;

public class Compiler {
    static String version = "v0.6.4";
    static String grammarName;
    static String startRuleName;
    static List<String> inputFiles = new ArrayList<String>();
    static boolean printAST = false;
    static boolean gui = false;
    static String psFile = null;
    static String outputFilename = null;
    static boolean showTokens = false;
    static boolean trace = true;
    static boolean diagnostics = false;
    static String encoding = null;
    static boolean inspectAST = false;
    static boolean SLL = false;
    static boolean nosemantic = true;
    static int verbose = 1;
    static String groupFile = "SmallPearlCpp.stg";
    static boolean lineSeparatorHasToBeModified = true;
    static boolean dumpDFA = false;
    static boolean dumpSymbolTable = true;
    static boolean dumpConstantPool = true;
    static boolean debug = false;
    static boolean debugSTG = false;
    static boolean stacktrace = false;
    static boolean exportSystemPart = false;
    static int     noOfErrors = 0;
    static int     noOfWarnings = 0;
    static int     warninglevel = 255;
    static int     lineWidth = 80;

    public static void main(String[] args) throws Exception {
        int i, j;
        if (args.length < 1) {
            printHelp();
            return;
        }

        if (!checkAndProcessArguments(args)) {
            return;
        }

        for (i = 0; i < inputFiles.size(); i++) {
            SmallPearlLexer lexer = null;
            try {
                lexer = new SmallPearlLexer(new ANTLRFileStream(inputFiles.get(i)));
            }
            catch(IOException ex) {
                System.out.println("Error:" + ex.getMessage());
                System.exit(-2);
            }

            lexer.removeErrorListeners();
            lexer.addErrorListener(DescriptiveErrorListener.INSTANCE);

            CommonTokenStream tokens = new CommonTokenStream(lexer);

            SmallPearlParser parser = new SmallPearlParser(tokens);

            parser.removeErrorListeners();
            parser.addErrorListener(DescriptiveErrorListener.INSTANCE);

            parser.setBuildParseTree(true);

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Start Analysis
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            System.out.println("Start compiling of:" + inputFiles.get(i).toString());

            System.out.println("Performing syntax check");

            ParserRuleContext tree = parser.program();

            System.out.flush();

            if (printAST) {
                System.out.println("Parse tree:");
                System.out.println(tree.toStringTree(parser));
            }

            if (inspectAST) {
                System.out.println("Inspect Parse tree:");
                // visualize parse tree in dialog box
                tree.inspect(parser);
                System.out.println("Press any key");
                try {
                    int ch = System.in.read();
                }
                catch (IOException ex) {
                }
            }

            if (dumpDFA) {
                parser.dumpDFA();
            }

            if (parser.getNumberOfSyntaxErrors() <= 0) {
                BuildSymbolTableVisitor buildSymbolTableVisitor = new BuildSymbolTableVisitor(verbose);
                buildSymbolTableVisitor.visit(tree);

                ConstantPoolVisitor constantPoolVisitor = new ConstantPoolVisitor(verbose,debug);
                constantPoolVisitor.visit(tree);

                ExpressionTypeVisitor expressionTypeVisitor = new ExpressionTypeVisitor(verbose,debug);
                expressionTypeVisitor.visit(tree);

                if (!nosemantic) {
                    SemanticCheckVisitor semanticCheckVisitor = new SemanticCheckVisitor(verbose);
                    semanticCheckVisitor.visit(tree);
                }

                if (exportSystemPart) {
                    SystemPartExport(lexer.getSourceName(),tree);
                }



//                try {
                    CppGenerate(lexer.getSourceName(), tree, expressionTypeVisitor);
/*                }
                catch(Exception ex) {
                    System.err.println(ex.getMessage());
                    System.err.println("Compilation aborted.");

                    if ( stacktrace )  {
                        System.err.println( getStackTrace(ex));
                    }

                    System.exit(-1);
                }
*/
                if (dumpSymbolTable) {
                    SymbolTable symtab = SymbolTable.getSymbolTable();
                    System.out.println(symtab);
                    symtab.getGlobalsDeclarations();
                    symtab.getProcedureDeclarations();
                }

                if (dumpConstantPool) {
                    constantPoolVisitor.dump();
                }

            }

            noOfErrors = parser.getNumberOfSyntaxErrors();

            System.out.flush();
            System.out.println("");
            System.out.println("Number of errors in " + inputFiles.get(i) + " encountered: " + noOfErrors);

            if ( noOfErrors == 0 ) {
                System.exit(0);
            } else {
                System.exit(1);
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public static void printHelp() {
        System.err.println("java org.smallpearl.compiler                             \n" +
                " Options:                                                           \n" +
                "  --help                      Print this help message               \n" +
                "  --version                   Print version information             \n" +
                "  --verbose                   Print more information                \n" +
                "  --quiet                     Be quiet                              \n" +
                "  --trace                                                           \n" +
                "  --nosemantic                Disable semantic checker              \n" +
                "  --printAST                  Print Abtract Syntax Tree             \n" +
                "  --inspectAST                Show graphical representation         \n" +
                "                              of the Abtract Syntax Tree            \n" +
                "  --dumpDFA                   Print DFA                             \n" +
                "  --dumpSymbolTable           Print the symboltable                 \n" +
                "  --dumpConstantPool          Print the constant pool               \n" +
                "  --debug                     Generate debug information            \n" +
                "  --debugSTG                  Start the stg debug gui               \n" +
                "  --stacktrace                Print stacktrace in case of an        \n" +
                "                              exception                             \n" +
                "  --warninglevel <level>      Set the warning level                 \n" +
                "                              Level   0: no warning                 \n" +
                "                              Level 255: all warnings (default)     \n" +
                " --export-systempart          Export the System part into a xml     \n" +
                "                              file                                  \n" +
                "  --output <filename>         Filename of the generated code        \n" +
                "  infile ...                                                        \n");
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public static boolean checkAndProcessArguments(String[] args) {
        int i = 0;

        while (i < args.length) {
            String arg = args[i];
            i++;
            if (arg.charAt(0) != '-') { // input file name
                inputFiles.add(arg);
                continue;
            }

            if (arg.equals("--help")) {
                printHelp();
                System.exit(0);
            } else if (arg.equals("--printAST")) {
                printAST = true;
            } else if (arg.equals("--inspectAST")) {
                inspectAST = true;
            } else if (arg.equals("--gui")) {
                gui = true;
            } else if (arg.equals("--tokens")) {
                showTokens = true;
            } else if (arg.equals("--trace")) {
                trace = true;
            } else if (arg.equals("--SLL")) {
                SLL = true;
            } else if (arg.equals("--nosemantic")) {
                nosemantic = true;
            } else if (arg.equals("--diagnostics")) {
                diagnostics = true;
            } else if (arg.equals("--dumpDFA")) {
                dumpDFA = true;
            } else if (arg.equals("--dumpSymbolTable")) {
                dumpSymbolTable = true;
            } else if (arg.equals("--dumpConstantPool")) {
                dumpConstantPool = true;
            } else if (arg.equals("--debug")) {
                debug = true;
            } else if (arg.equals("--debugSTG")) {
                debugSTG = true;
            } else if (arg.equals("--stacktrace")) {
                stacktrace = true;
            } else if (arg.equals("--export-systempart")) {
                exportSystemPart = true;
            } else if (arg.equals("--output")) {
                if (i >= args.length) {
                    System.err.println("missing filename on --output");
                    return false;
                }
                outputFilename = args[i];
                i++;
                continue;
            } else if (arg.equals("-encoding")) {
                if (i >= args.length) {
                    System.err.println("missing encoding on -encoding");
                    return false;
                }
                encoding = args[i];
                i++;
            } else if (arg.equals("--ps")) {
                if (i >= args.length) {
                    System.err.println("missing filename on --ps");
                    return false;
                }
                psFile = args[i];
                i++;
            } else if (arg.equals("--version")) {
                    System.out.println("OpenPEARL90 compiler version "+version);
                i++;
            } else if (arg.equals("--warninglevel")) {
                if (i >= args.length) {
                    System.err.println("missing warning level on --warninglevel");
                    return false;
                }
                warninglevel = Integer.parseInt(args[i]);
                i++;
            }
        }

        return true;
    }

    private static Void CppGenerate(String sourceFileName, ParserRuleContext tree, ExpressionTypeVisitor expressionTypeVisitor) {
        CppCodeGeneratorVisitor cppCodeGenerator = new CppCodeGeneratorVisitor(sourceFileName, groupFile, verbose, debug, expressionTypeVisitor);
        ST code = cppCodeGenerator.visit(tree);

        if ( debugSTG ) {
            System.out.println( "Press a key to continue" );
            code.inspect();
            try {
                int ch = System.in.read();
            }
            catch (IOException ex) {
            }
        }

        if (outputFilename != null) {
            try {
                if ( outputFilename.lastIndexOf(".") == - 1 ) {
                    outputFilename += ".cc";
                }

                if (verbose>0) {
                    System.out.println("Generating output file "+outputFilename);
                }

                PrintWriter writer = new PrintWriter(outputFilename, "UTF-8");
                writer.println(code.render(lineWidth));
                writer.close();
            } catch (IOException e) {
                System.err.println("Problem writing to the file " + outputFilename);
            }
        } else {
            if(verbose>0) {
                System.out.println("Generated output:");
            }

            System.out.println(code.render(lineWidth));
        }

        return null;
    }

    private static Void SystemPartExport(String sourceFileName, ParserRuleContext tree) {
        String outputFileName = sourceFileName;

        SystemPartExporter  systemPartExporter = new SystemPartExporter(sourceFileName,verbose, debug);
        ST systemPart = systemPartExporter.visit(tree);

        if ( debugSTG ) {
            System.out.println( "Press a key to continue" );
            systemPart.inspect();
            try {
                int ch = System.in.read();
            }
            catch (IOException ex) {
            }
        }

        outputFileName = outputFileName.substring(0, outputFileName.lastIndexOf('.'));
        outputFileName = outputFileName.concat(".xml");

        try {

            if (verbose>0) {
                System.out.println("Generating export file "+outputFileName);
            }

            PrintWriter writer = new PrintWriter(outputFileName, "UTF-8");
            writer.println(systemPart.render(lineWidth));
            writer.close();
        } catch (IOException e) {
            System.err.println("Problem writing to the export file " + outputFileName);
        }

        return null;
    }

    static String getStackTrace(Throwable t) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw, true);
        t.printStackTrace(pw);
        pw.flush();
        sw.flush();
        return sw.toString();
    }
}

