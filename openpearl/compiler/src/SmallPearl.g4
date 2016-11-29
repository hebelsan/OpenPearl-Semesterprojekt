/*
 [The "BSD license"]
 Copyright (c) 2012-2014 Marcel Schaible
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

grammar SmallPearl;

////////////////////////////////////////////////////////////////////////////////

@header
{
    package org.smallpearl.compiler;
}

////////////////////////////////////////////////////////////////////////////////

tokens {
     Letter,
     Digit,
     Sign
}

////////////////////////////////////////////////////////////////////////////////
// Excerpt from PEARL 90 LANGUAGE REPORT, Version 2.2 September 1998, page 135
//
// Following meta characters are used in the syntax description:
//
// meta character      meaning
// --------------      ---------------------------------------------------------
// ::=                 introduction of a Name (nonterminal symbol) for a language
//                     form
// []                  bracketing of optional parts of a language form
// |                   separation of alternative parts of a language form
// {}                  putting together several elements to a new element
// ...                 one or multiple repetition of the preceding element
//                     (or of several elements bracketed by { } or [ ] )
// §                   separates an explaining comment from a language form Name
// /∗ ∗/               comment brackets: includes an explaining text, possibly
//                     explaining the language form in detail instead of a formal
//                     description
//
// All other elements occurring in the syntax rules are either Names of language
// forms or terminal symbols. Examples for terminal symbols are the PEARL keywords
// or the characters semicolon “;”, opening round bracket “(” and closing round
// bracket “)”, or the apostrophe “ ’ ”; the terminal symbols opening square
// bracket “[” and closing square bracket “]” are printed boldly to distinguish
// them from the meta symbols for optional parts. Attention: the round brackets
// are no meta characters and have thus no grouping effect!
////////////////////////////////////////////////////////////////////////////////

program:
  module+
  ;

////////////////////////////////////////////////////////////////////////////////

module:
  'MODULE' ( '(' ID ')' | ID ) ';' cpp_inline* system_part? problem_part? 'MODEND' ';'
  ;

////////////////////////////////////////////////////////////////////////////////

system_part:
    'SYSTEM' ';'
    ( username_declaration | cpp_inline )*
    ;

////////////////////////////////////////////////////////////////////////////////
//  SystemName ::=
//    Identifier [ (nni§index) ]
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  nni ::= IntegerWithoutPrecision§NonNegative
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ExtensionProcessDevice ::=
//  ⇤nni§ChannelNumber [ ⇤nni§Position [ , nni§Width ] ]
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  DeviceAssociation ::=
//    UserName: SystemName [ ExtensionProcessDevice ]
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  UserName ::= Identifier
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  SystemName   Device
//  -----------  -------------------------------------------------
//  STDIN        standard input (console)
//  STDOUT       standard output (console)
//  SERIAL       for I/O with serial interfaces
//  DISC         for reading and writing files (disk, floppy,...)
//  DIGIO        digital I/O
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  DationSpecification ::=
//    { SPECIFY | SPC } IdentifierDenotation TypeDation [ GlobalAttribute ] ;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  DationDeclaration ::=
//    {DECLARE | DCL} IdentifierDenotation TypeDation [GlobalAttribute]
//    CREATED (Name§SystemDefDation);
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  TypeDation ::=
//    DATION SourceSinkAttribute ClassAttribute [ Structure ] [ AccessAttribute ]
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  SourceSinkAttribute ::=
//    IN | OUT | INOUT
////////////////////////////////////////////////////////////////////////////////

problem_part:
    'PROBLEM' ';'
    ( scalarVariableDeclaration | semaDeclaration | identification | dationSpecification | dationDeclaration | cpp_inline )*
    ( taskDeclaration | procedureDeclaration | cpp_inline )*
    ;

////////////////////////////////////////////////////////////////////////////////

// Changes added by Hertwig ////////////////////////////////////////////////////
//
// Possible composition of the PEARL system part (new syntax)
// Thus the grammar must be capable of dealing with this type of declaration
// ...
// i2cbus : i2cbus_1 ('/dev/i2cbus', 100000);
// tempsensor : i2cbus <- LM75(100.000);	1st version
// tempsensor : IN : i2cbus <--- LM75(100.000);	2nd version
// tempsensor : IN : i2cbus --- LM75(100.000);	3rd version (final)

username_declaration:
    ID ':' (username_declaration_without_data_flow_direction |
			username_declaration_with_data_flow_direction) ';'
	;

////////////////////////////////////////////////////////////////////////////////

username_declaration_without_data_flow_direction:
	peripheral_name username_parameters?
	;

////////////////////////////////////////////////////////////////////////////////

username_declaration_with_data_flow_direction:
    data_flow_direction ':' connection_name '---' peripheral_name username_parameters?
    ;

////////////////////////////////////////////////////////////////////////////////

data_flow_direction:
	  'IN'
	| 'OUT'
    | 'INOUT'
    ;

////////////////////////////////////////////////////////////////////////////////

connection_name:
    ID
    ; 

////////////////////////////////////////////////////////////////////////////////

peripheral_name:
    ID
    ;

////////////////////////////////////////////////////////////////////////////////

username_parameters:
    '(' literal (',' literal)* ')'
    ;

////////////////////////////////////////////////////////////////////////////////
// TODO: Identification ::=
//           { SPECIFY | SPC } Identifier [ AllocationProtection ] Type IdentificationAttribute ;

identification:
    ( 'SPECIFY' | 'SPC' ) ID  allocation_protection? type? identification_attribute? ';'
    ;

////////////////////////////////////////////////////////////////////////////////

allocation_protection:
    ID
    ;

////////////////////////////////////////////////////////////////////////////////
//  IdentificationAttribute ::=
//    IDENT ( Name§Object )
////////////////////////////////////////////////////////////////////////////////

identification_attribute:
    ID '(' ID ')'
    ;

////////////////////////////////////////////////////////////////////////////////
//
//  ScalarVariableDeclaration ::=
//      { DECLARE | DCL } VariableDenotation [ , VariableDenotation ] ... ;
//
//  VariableDenotation ::=
//      IdentifierDenotation [ AllocationProtection ] TypeAttribute [ GlobalAttribute ] [ InitialisationAttribute ]
//
//  IdentifierDenotation ::=
//      Identifier | (Identifier [ , Identifier ] ... )
//
//  TypeAttribute ::=
//      SimpleType | TypeReference | Identifier§ForType
//
//  SimpleType ::=
//      TypeInteger | TypeFloatingPointNumber | TypeBitString | TypeCharacterString | TypeTime | TypeDuration
//
//  InitialisationAttribute ::=
//      { INITIAL | INIT } ( InitElement [ , InitElement ] ... )
//
//  InitElement ::= Constant
//      | Identifier§NamedConstant | ConstantExpression ...
//
//  Constant ::= Integer
//      | FloatingPointNumber | BitStringConstant
//      | TimeConstant
//      | DurationConstant
//      | NIL
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  ScalarVariableDeclaration ::=
//      { DECLARE | DCL } VariableDenotation [ , VariableDenotation ] ... ;
////////////////////////////////////////////////////////////////////////////////

scalarVariableDeclaration :
    ( 'DECLARE' | 'DCL' ) variableDenotation ( ',' variableDenotation )* ';'
    | cpp_inline
    ;

////////////////////////////////////////////////////////////////////////////////
//  VariableDenotation ::=
//      IdentifierDenotation [ AllocationProtection ] TypeAttribute [ GlobalAttribute ] [ InitialisationAttribute ]
////////////////////////////////////////////////////////////////////////////////

variableDenotation :
    identifierDenotation allocationProtection? typeAttribute globalAttribute? initialisationAttribute?
    ;

////////////////////////////////////////////////////////////////////////////////

allocationProtection :
    'INV'
    ;

////////////////////////////////////////////////////////////////////////////////
// GlobalAttribute ::=
//      GLOBAL [ (Identifier§OfaModule) ]
////////////////////////////////////////////////////////////////////////////////

globalAttribute :
    'GLOBAL'  ( '(' ID ')' )?
    ;
    
////////////////////////////////////////////////////////////////////////////////
//  TypeAttribute ::=
//      SimpleType | TypeReference | Identifier§ForType
////////////////////////////////////////////////////////////////////////////////

typeAttribute :
      simpleType 
    ;

////////////////////////////////////////////////////////////////////////////////
// SimpleType ::=
//    TypeInteger | TypeFloatingPointNumber | TypeBitString | TypeCharacterString | TypeTime | TypeDuration
////////////////////////////////////////////////////////////////////////////////

simpleType :
       typeInteger 
     | typeFloatingPointNumber
     | typeBitString 
     | typeCharacterString 
     | typeTime
     | typeDuration
    ;
    
////////////////////////////////////////////////////////////////////////////////
// TypeInteger ::=
//      FIXED [ (Precision) ] 
////////////////////////////////////////////////////////////////////////////////

typeInteger :
    'FIXED' ( '(' mprecision ')' )?
    ;

////////////////////////////////////////////////////////////////////////////////
// Precision ::=
//      IntegerWithoutPrecision§GreaterZero    
////////////////////////////////////////////////////////////////////////////////

mprecision :
    integerWithoutPrecision
    ;
 
integerWithoutPrecision :
    IntegerConstant
    ;

typeReference :
    ;

typeFloatingPointNumber :
    'FLOAT' ( '(' IntegerConstant ')' )?
    ;

typeBitString :
    'BIT' ( '(' IntegerConstant ')' )?
    ;
    
typeCharacterString :
    ( 'CHARACTER' | 'CHAR' ) ( '(' IntegerConstant ')' )?
    ;

typeDuration :
    'DURATION' | 'DUR'
    ;

////////////////////////////////////////////////////////////////////////////////
//  IdentifierDenotation ::=
//      Identifier | (Identifier [ , Identifier ] ... )
////////////////////////////////////////////////////////////////////////////////

identifierDenotation :
    ID | '(' ID ( ',' ID )*  ')'
    ;

////////////////////////////////////////////////////////////////////////////////
//  InitialisationAttribute ::=
//      { INITIAL | INIT } ( InitElement [ , InitElement ] ... )
////////////////////////////////////////////////////////////////////////////////

initialisationAttribute :
    ( 'INITIAL' | 'INIT' ) '(' initElement ( ',' initElement )* ')'
    ;

////////////////////////////////////////////////////////////////////////////////
//  InitElement ::= Constant
//      | Identifier§NamedConstant | ConstantExpression ...
////////////////////////////////////////////////////////////////////////////////

initElement :
    constant
    ;

////////////////////////////////////////////////////////////////////////////////

variable_init :
    'INIT' '(' constant ')'
    ;

////////////////////////////////////////////////////////////////////////////////
//  SemaDeclaration ::=
//   { DECLARE | DCL } Identifier or IdentifierList [ DimensionAttribute ] SEMA [ GlobalAttribute ]
////////////////////////////////////////////////////////////////////////////////

semaDeclaration :
    ( 'DECLARE' | 'DCL' ) identifierDenotation 'SEMA' globalAttribute? preset? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
//   [ PRESET (IntegerWithoutPrecision [ , IntegerWithoutPrecision ] ... ) ];
////////////////////////////////////////////////////////////////////////////////

preset :
    'PRESET' '(' integerWithoutPrecision (',' integerWithoutPrecision )* ')'
    ;

////////////////////////////////////////////////////////////////////////////////
// ProcedureDeclaration ::=
//   Identifier: { PROCEDURE | PROC } [ ListOfFormalParameters ] [ ResultAttribute ] [ GlobalAttribute ] ;
//      ProcedureBody
//   END;
////////////////////////////////////////////////////////////////////////////////

procedureDeclaration
    : ID ':' ( 'PROCEDURE' | 'PROC' ) listOfFormalParameters? resultAttribute? globalAttribute? ';'
        procedureBody
      'END' ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// ProcedureBody ::=
//   [ Declaration... ] [ Statement... ]
////////////////////////////////////////////////////////////////////////////////

procedureBody :
    scalarVariableDeclaration*
    statement*
    ;

////////////////////////////////////////////////////////////////////////////////
// ListOfFormalParameters ::=
//   (FormalParameter [ , FormalParameter ]...)
////////////////////////////////////////////////////////////////////////////////

listOfFormalParameters :
   '(' formalParameter ( ',' formalParameter )* ')'
   ;

////////////////////////////////////////////////////////////////////////////////
// TODO: FormalParameter ::=
//   Identifier or IdentifierList [ VirtualDimensionList ] [ AssignmentProtection ] ParameterType [ IDENTICAL | IDENT ]
////////////////////////////////////////////////////////////////////////////////

formalParameter :
    ( ID | '(' ID ( ',' ID)* ')' ) assignmentProtection? parameterType passIdentical?
    ;


assignmentProtection :
    'INV'
    ;

passIdentical:
    'IDENTICAL' | 'IDENT'
    ;

////////////////////////////////////////////////////////////////////////////////
// TODO: VirtualDimensionList ::= ([,... ])
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TODO: ParameterType ::=
//   SimpleType | TypeReference | TypeStructure
//  | Identifier§ForType | TypeDation | TypeRealTimeObject
////////////////////////////////////////////////////////////////////////////////

parameterType :
      simpleType
    | typeDation
    ;

////////////////////////////////////////////////////////////////////////////////
// TODO: TypeRealTimeObject ::=
//   SEMA | BOLT | IRPT | INTERRUPT | SIGNAL
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// DisableStatement ::=
//   DISABLE Name§Interrupt;
////////////////////////////////////////////////////////////////////////////////

disableStatement :
    'DISABLE' ID ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// EnableStatement ::=
//   ENABLE Name§Interrupt;
////////////////////////////////////////////////////////////////////////////////

enableStatement :
    'ENABLE' ID ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// TriggerStatement ::=
//   TRIGGER Name§Interrupt;
////////////////////////////////////////////////////////////////////////////////

triggerStatement :
    'TRIGGER' ID ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// ResultAttribute ::=
//   RETURNS(ResultType)
////////////////////////////////////////////////////////////////////////////////

resultAttribute :
    'RETURNS' '(' resultType ')'
    ;

////////////////////////////////////////////////////////////////////////////////
// ResultType ::=
//   SimpleType | TypeReference | TypeStructure | Identifier§ForType
////////////////////////////////////////////////////////////////////////////////

resultType :
      simpleType
    | typeReference
    | ID
    ;

////////////////////////////////////////////////////////////////////////////////
// TODO: { SPECIFY | SPC } Identifier§Procedure { ENTRY | [ : ] PROC }
//   [ ListOfParametersFor-SPC ] [ResultAttribute ] GlobalAttribute ;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TODO: ListOfParametersFor-SPC ::=
//   (ParameterSpecification [ , ParameterSpecification ]...)
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// TODO: ParameterSpecification ::=
//   [ Identifier ] [ VirtualDimensionList ] [ AssignmentProtection ] ParameterType [ IDENTICAL | IDENT ]
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TaskDeclaration ::=
//   Identifier: TASK [ PriorityAttribute ] [ MAIN ] [ GlobalAttribute ] ; TaskBody
//  END;
////////////////////////////////////////////////////////////////////////////////

taskDeclaration :
    ID ':' 'TASK' priority? task_main? ';' taskBody 'END' ';' cpp_inline?
    ;

////////////////////////////////////////////////////////////////////////////////

task_main: 'MAIN';

////////////////////////////////////////////////////////////////////////////////

taskBody:
    ( scalarVariableDeclaration | dationDeclaration )*
    procedureDeclaration*
    statement*
    ;


////////////////////////////////////////////////////////////////////////////////

statement:
      label_statement* ( unlabeled_statement | block_statement | cpp_inline )  ;

////////////////////////////////////////////////////////////////////////////////

unlabeled_statement:
      empty_statement
    | realtime_statement
    | interrupt_statement
    | assignment_statement
    | sequential_control_statement
    | io_statement
    | callStatement
    | returnStatement
    | gotoStatement
    | loopStatement
    | exitStatement
    ;

////////////////////////////////////////////////////////////////////////////////

empty_statement
    : ';'
    ;

////////////////////////////////////////////////////////////////////////////////

label_statement
    : ID ':'
    ;

////////////////////////////////////////////////////////////////////////////////
// CallStatement ::=
//   [ CALL ] Name§SubprogramProcedure [ ListOfActualParameters ] ;
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ListOfActualParameters ::=
//   (Expression [ , Expression ]...)
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Example:
// SPC Output PROC (P FIXED, N FIXED) GLOBAL;
// DCL (Pos, No) FIXED;
// ...
// ! Assignments to Pos and No
// CALL Output (Pos, No);
////////////////////////////////////////////////////////////////////////////////

callStatement
    : 'CALL'? ID listOfActualParameters?  ';'
    ;

////////////////////////////////////////////////////////////////////////////////

listOfActualParameters
    : '(' expression  ( ',' expression )* ')'
    ;

////////////////////////////////////////////////////////////////////////////////
// ReturnStatement ::=
//   RETURN [ ( Expression ) ] ;
////////////////////////////////////////////////////////////////////////////////

returnStatement
    : 'RETURN' ( '(' expression ')' )? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// GoToStatement ::=
//   GOTO Identifier§Label ;
////////////////////////////////////////////////////////////////////////////////

gotoStatement
    : 'GOTO' ID ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// ExitStatement ::=
//   EXIT [ Identifier§BlockOrLoop ] ;
////////////////////////////////////////////////////////////////////////////////

exitStatement
    : 'EXIT' ID? ';'
    ;

////////////////////////////////////////////////////////////////////////////////

assignment_statement
    : ID ( ':=' | '=' ) expression ';'
    ;
////////////////////////////////////////////////////////////////////////////////

sequential_control_statement
    : if_statement
    | case_statement
    ;

////////////////////////////////////////////////////////////////////////////////
// IfStatement ::=
//   IF Expression§OfType-BIT(1)
//   THEN [ Statement ... ]
//  [ ELSE [ Statement ... ] ] FIN ;
////////////////////////////////////////////////////////////////////////////////

if_statement
    : 'IF' expression then_block else_block? 'FIN' ';'
    ;

////////////////////////////////////////////////////////////////////////////////

then_block
    : 'THEN' statement+
    ;

////////////////////////////////////////////////////////////////////////////////

else_block
    : 'ELSE' statement+
    ;

////////////////////////////////////////////////////////////////////////////////
// CaseStatement ::=
//   StatementSelection1 | StatementSelection2
////////////////////////////////////////////////////////////////////////////////

case_statement
    : 'CASE' ( case_statement_selection1 | case_statement_selection2 ) 'FIN' ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// CaseStatement1 ::=
//   CASE Expression§WithIntegerAsValue
//     { ALT [ Statement ... ] } ...
//     [ OUT [ Statement ... ] ]
//   FIN ;
////////////////////////////////////////////////////////////////////////////////

case_statement_selection1
    : expression case_statement_selection1_alt+ case_statement_selection_out?
    ;

case_statement_selection1_alt
    : 'ALT' statement+
    ;

case_statement_selection_out
    : 'OUT' statement+
    ;

////////////////////////////////////////////////////////////////////////////////
// CaseStatement2 ::=
//   CASE CaseIndex
//     { ALT ( CaseList ) [ Statement ... ] }...
//     [ OUT [ Statement ... ] ]
//    FIN ;
////////////////////////////////////////////////////////////////////////////////
// CaseIndex ::=
//    Expression§WithValueOfType-FIXED-Or-CHAR(1)
////////////////////////////////////////////////////////////////////////////////

case_statement_selection2
    : expression case_statement_selection2_alt+ case_statement_selection_out?
    ;

case_statement_selection2_alt
    : 'ALT' case_list statement+
    ;

////////////////////////////////////////////////////////////////////////////////
// CaseList ::=
//   IndexSection [ , IndexSection ] ...
////////////////////////////////////////////////////////////////////////////////

case_list
    : '(' index_section ( ',' index_section)*  ')'
    ;

////////////////////////////////////////////////////////////////////////////////
//  IndexSection::=
//    Constant-FIXED-Expression [ : Constant-FIXED-Expression ]
//    | CharacterStringConstant§OfLength1 [ : CharacterStringConstant§OfLength1 ]
////////////////////////////////////////////////////////////////////////////////

index_section
    : expression ( ':' expression )?
    ;

////////////////////////////////////////////////////////////////////////////////
//  Block::=
//    BEGIN
//      [{ Declaration | Identification } ... ] [ Statement ... ]
//    END [ Identifier§Block ] ;
////////////////////////////////////////////////////////////////////////////////

block_statement:
    'BEGIN'
    ( scalarVariableDeclaration | dationDeclaration )*
    statement*
    'END' ID? ';'
    ;
////////////////////////////////////////////////////////////////////////////////

//  LoopStatement ::=
//    [ FOR Indicator§ControlVariable ] [ FROM Expression§InitialValue ] [ BY Expression§StepLength ]
//    [ TO Expression§EndValue ]
//    [ WHILE Expression§Condition ] REPEAT
//    [{ Declaration | Identification }... ]
//    [ Statement ... ] END [ Identifier§Loop ] ;
////////////////////////////////////////////////////////////////////////////////

loopStatement:
    loopStatement_for? loopStatement_from? loopStatement_by? loopStatement_to? loopStatement_while?
    'REPEAT'
    ( scalarVariableDeclaration | dationDeclaration )*
    statement*
    loopStatement_end ';'
    ;

loopStatement_for:
    'FOR' ID
     ;

loopStatement_from:
    'FROM' expression
     ;

loopStatement_by:
    'BY' expression
    ;

loopStatement_to:
    'TO' expression
     ;

loopStatement_while:
    'WHILE' expression
    ;

loopStatement_end:
    'END' ID?
    ;

////////////////////////////////////////////////////////////////////////////////

realtime_statement
    : task_control_statement
    | task_coordination_statement
    ;

////////////////////////////////////////////////////////////////////////////////

task_control_statement
    : taskStart
    | task_terminating
    | task_suspending
    | taskContinuation
    | taskResume
    | task_preventing
    ;

////////////////////////////////////////////////////////////////////////////////

task_terminating
    : 'TERMINATE' ID? ';'
    ;

////////////////////////////////////////////////////////////////////////////////

task_suspending
    : 'SUSPEND' ID? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// TaskContinuation ::=
//     [ SimpleStartCondition ] CONTINUE [ Name§Task ] [ Priority ]
//
//  SimpleStartCondition ::=
//      AT Expression§Time | AFTER Expression§Duration | WHEN Name§Interrupt
////////////////////////////////////////////////////////////////////////////////

taskContinuation
    : startCondition? 'CONTINUE' ID? priority? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
//
// TaskDelay ::=
//      SimpleStartCondition RESUME;
//
// SimpleStartCondition ::=
//     AT Expression§Time | AFTER Expression§Duration | WHEN Name§Interrupt
////////////////////////////////////////////////////////////////////////////////

taskResume
    : startCondition 'RESUME' ';'
    ;

////////////////////////////////////////////////////////////////////////////////

task_preventing
    : 'PREVENT' ID? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// TaskStart ::=
//      [ StartCondition ] ACTIVATE Name§Task [ Priority ];
////////////////////////////////////////////////////////////////////////////////

taskStart
    : startCondition? frequency?'ACTIVATE' ID  priority? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// Priority ::=
//   { PRIORITY | PRIO } Expression§WithPositiveIntegerAsValue
////////////////////////////////////////////////////////////////////////////////

priority
    : ( 'PRIORITY' | 'PRIO' ) IntegerConstant
    ;

////////////////////////////////////////////////////////////////////////////////
// Frequency ::=
//   ALL Expression§Duration [ { UNTIL Expression§Time } | { DURING Expression§Duration } ]
////////////////////////////////////////////////////////////////////////////////

frequency
    : 'ALL' durationConstant ( 'UNTIL' timeConstant |  'DURING' durationConstant )?
    ;

////////////////////////////////////////////////////////////////////////////////
// StartCondition ::=
//   AT Expression§Time [ Frequency ]
//   | AFTER Expression§Duration [ Frequency ]
//   | WHEN Name§Interrupt [ AFTER Expression§Duration ] [ Frequency ]
//   | Frequency
////////////////////////////////////////////////////////////////////////////////
// SimpleStartCondition ::=
//   AT Expression§Time | AFTER Expression§Duration | WHEN Name§Interrupt
////////////////////////////////////////////////////////////////////////////////

startCondition
    :
      'AFTER'   durationConstant                                # startConditionAFTER
    | 'AT'      timeConstant                                    # startConditionAT
    | 'WHEN'    ID  ( 'AFTER' durationConstant)?  frequency?    # startConditionWHEN
    ;


////////////////////////////////////////////////////////////////////////////////

task_coordination_statement
    : semaRequest
    | semaRelease
    ;

////////////////////////////////////////////////////////////////////////////////
// REQUEST Name§Sema [ , Name§Sema ]... ;
////////////////////////////////////////////////////////////////////////////////

semaRequest
    : 'REQUEST' ID ( ',' ID)* ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// RELEASE Name§Sema [ , Name§Sema ]...;
////////////////////////////////////////////////////////////////////////////////

semaRelease
    : 'RELEASE' ID ( ',' ID)* ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// TRY Name§Sema;
////////////////////////////////////////////////////////////////////////////////

semaTry
    : 'TRY' ID ( ',' ID)*
    ;

////////////////////////////////////////////////////////////////////////////////
// BoltDeclaration ::=
//   { DECLARE | DCL } Identifier or IdentifierList [ DimensionAttribute ] BOLT [ GlobalAttribute ] ;
//
// BoltSpecification ::=
//   { SPECIFY | SPC } Identifier or IdentifierList [ VirtualDimensionAttribute ]
//   BOLT { GlobalAttribute | IdentificationAttribute } ;
//
// BoltStatement ::=
//      RESERVE Name§Bolt [ , Name§Bolt ] ... ;
//    | FREE    Name§Bolt [ , Name§Bolt ] ... ;
//    | ENTER   Name§Bolt [ , Name§Bolt ] ... ;
//    | LEAVE   Name§Bolt [ , Name§Bolt ] ... ;
////////////////////////////////////////////////////////////////////////////////

// boltStatement :
//       reserve
//     | free
//     | enter
//     | leave
//     ;

////////////////////////////////////////////////////////////////////////////////

// reserve:
//     'RESERVE'  ID ( ',' ID)* ';'
//      ;

////////////////////////////////////////////////////////////////////////////////

// free:
//     'FREE' ID ( ',' ID)* ';'
//      ;

////////////////////////////////////////////////////////////////////////////////

// enter:
//     'ENTER'   ID ( ',' ID)* ';'
//     ;

////////////////////////////////////////////////////////////////////////////////

// leave:
//     'LEAVE'   ID ( ',' ID)* ';'
//     ;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Interrupt-Anweisung ::=
//   { ENABLE | DISABLE | TRIGGER } Name§Interrupt ;
////////////////////////////////////////////////////////////////////////////////

interrupt_statement :
      enableStatement
    | disableStatement
    | triggerStatement
    ;

io_statement:
      open_statement
    | close_statement
    | putStatement
    | getStatement
    | writeStatement
    | readStatement
    | sendStatement
    | takeStatement
    ;

////////////////////////////////////////////////////////////////////////////////

// OpenStatement ::=
//      OPEN Name§Dation [ BY OpenParameter [ , OpenParameter ] ... ] ;
//
// When executing the open statement, a data station with typology is positioned at its beginning.
// The open parameters serve to handle data stations containing identifyable files. E.g., a system
// defined data station Disk can possess a file TAB1, which is also maintained after terminating the program under
// this name. Later on, the same or another program can create a user defined data station Table on Disk,
// identified with file TAB1 in the open statement.
//
// OpenParameter ::=
//      IDF ( {Name§CharacterVariable | CharacterStringConstant } ) | RST (Name§ErrorVariable-FIXED) |
//      { OLD | NEW | ANY } |
//      { CAN | PRM }

open_statement:
    'OPEN' ID ( 'BY' open_parameterlist )? ';'
    ;

////////////////////////////////////////////////////////////////////////////////

open_parameterlist:
    open_parameter (',' open_parameter)*
    ;

////////////////////////////////////////////////////////////////////////////////

open_parameter:
    'IDF' '(' ( ID | StringLiteral ) ')'  # open_parameter_idf
    | 'RST' '(' ID ')'                    # open_parameter_rst
    | open_parameter_old_new_any          # open_parameter_old_or_new_or_any
    | open_parameter_can_prm              # open_parameter_can_or_prm
    ;

////////////////////////////////////////////////////////////////////////////////

open_parameter_old_new_any:
      'OLD'                                # open_parameter_old
    | 'NEW'                                # open_parameter_new
    | 'ANY'                                # open_parameter_any
    ;

open_parameter_can_prm:
      'CAN'                                 # open_parameter_can
    | 'PRM'                                 # open_parameter_prm
    ;

////////////////////////////////////////////////////////////////////////////////
// CloseStatement ::=
//   CLOSE Name§Dation [ BY CloseParameter [ , CloseParameter ] ... ] ;
////////////////////////////////////////////////////////////////////////////////

close_statement:
    'CLOSE' ID ( 'BY' close_parameterlist)? ';'
    ;

////////////////////////////////////////////////////////////////////////////////

close_parameterlist:
    close_parameter (',' close_parameter)*
    ;

////////////////////////////////////////////////////////////////////////////////
// CloseParameter ::=
//   CAN | PRM | RST (Name§ErrorVariable-FIXED)
////////////////////////////////////////////////////////////////////////////////

 close_parameter :
       'CAN'                  # close_parameter_can
     | 'PRM'                  # close_parameter_prm
     | 'RST' '(' ID ')'       # close_parameter_rst
     ;

////////////////////////////////////////////////////////////////////////////////
// GetStatement ::=
//   GET [ { Name§Variable | Segment } [ , { Name§Variable | Segment } ] ... ] FROM Name§Dation [ BY FormatPosition [ , FormatPosition ] ... ] ;
////////////////////////////////////////////////////////////////////////////////

getStatement :
    'GET' ( ID ( ',' ID )* )?  getFrom 'BY' formatPosition ( ',' formatPosition )* ';'
    ;


 getFrom :
    'FROM' ID
    ;


////////////////////////////////////////////////////////////////////////////////
// PutStatement ::=
//   PUT [ { Expression | Segment } [ , { Expression | Segment } ] ... ] TO Name§Dation [ BY FormatPosition [ , FormatPosition ] ... ] ;
////////////////////////////////////////////////////////////////////////////////

putStatement :
    'PUT' ( expression ( ',' expression )* )? 'TO' ID
    ( 'BY' formatPosition ( ',' formatPosition )* )? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// FormatPosition ::=
//   [ Factor ] { Format | Position } |
//   Factor ( FormatPosition [ , FormatPosition ] ... )
////////////////////////////////////////////////////////////////////////////////

formatPosition :
      factor? format                                             # factorFormat
    | factor? position                                           # factorPosition
    | factor '(' formatPosition ( ( ','  formatPosition )* )?')' # factorFormatPosition
    ;

////////////////////////////////////////////////////////////////////////////////
// Factor ::=
//   ( Expression§IntegerGreaterZero ) | IntegerWithoutPrecision§GreaterZero
////////////////////////////////////////////////////////////////////////////////

factor :
    '(' expression ')' | integerWithoutPrecision
    ;

////////////////////////////////////////////////////////////////////////////////
// Format ::=
//   FixedFormat | FloatFormat | CharacterStringFormat | BitFormat | TimeFormat | DurationFormat | ListFormat | R-Format | RST (Name)
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Format ::=
//   { F | E} ( Expression [ , Expression [ , Expression ] ] ) | { B | B1 | B2 | B3 | B4 | A } [ ( Expression ) ]
//   | { T | D } ( Expression [ , Expression ] )
//   | LIST
//   | R ( Identifier§Format )
//   | S ( Name§LengthVariable-FIXED )
////////////////////////////////////////////////////////////////////////////////

format :
    fixedFormat | characterStringFormat
    ;

////////////////////////////////////////////////////////////////////////////////
// Position ::=
//   RST ( Name§ErrorVariable-FIXED )
//   | { X | SKIP | PAGE } [ ( Expression ) ]
//   | { POS | ADV } ( Expression [ , Expression [ , Expression ] ] )
//   | { COL | LINE } ( Expression )
//   | SOP ( Name [ , Name [ , Name ] ] /∗ PositionVariables-FIXED ∗/ )
////////////////////////////////////////////////////////////////////////////////

position :
      'RST' ( '(' ID ')' )               # positionRST
    | 'SKIP' ( '(' expression ')' )?     # positionSKIP
    | 'X' ( '(' expression ')' )?        # positionX
    ;

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// FixedFormat ::=
//   F (FieldWidth [ , DecimalPositions [ , ScaleFactor ] ] )
////////////////////////////////////////////////////////////////////////////////

fixedFormat :
    'F' '(' fieldWidth ( ',' decimalPositions ( ',' scaleFactor )? )? ')'
    ;

////////////////////////////////////////////////////////////////////////////////
// FieldWidth ::= Expression§WithPositiveIntegerAsValue
////////////////////////////////////////////////////////////////////////////////

fieldWidth :
    expression
    ;

////////////////////////////////////////////////////////////////////////////////
// DecimalPositions ::= Expression§WithNonNegativeIntegerAsValue
////////////////////////////////////////////////////////////////////////////////

decimalPositions :
    expression
    ;

////////////////////////////////////////////////////////////////////////////////
// ScaleFactor ::= Expression§WithIntegerAsValue
////////////////////////////////////////////////////////////////////////////////

scaleFactor :
    expression
    ;

////////////////////////////////////////////////////////////////////////////////
// CharacterStringFormat ::=
//   A [ (Expression§NumberCharacters) ] | S (Name§NumberCharactersVariableFixed)
////////////////////////////////////////////////////////////////////////////////

characterStringFormat :
      'A' ( '(' expression ')' )?       # characterStringFormatA
    | 'S' '(' ID ')'                    # characterStringFormatS
    ;

////////////////////////////////////////////////////////////////////////////////

channel: ID;

////////////////////////////////////////////////////////////////////////////////
// WriteStatement ::=
//  WRITE [ { Expression | Segment } [ , { Expression | Segment } ] ... ]
//     TO Name§Dation [ BY Position [ , Position ] ... ] ;
//
// Segment ::=
//   Name§Field ( [ Index , ] ... Index : Index)
//
// Index ::=
//   Expression§WithIntegerAsValue
////////////////////////////////////////////////////////////////////////////////

writeStatement :
    'WRITE' ( expression ( ',' expression )* )? 'TO' ID
    ( 'BY' writePosition ( ',' writePosition )* )? ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// ReadStatement ::=
//   READ [ { Name§Variable | Segment } [ , { Name§Variable | Segment } ] ... ] FROM Name§Dation [ BY Position [ , Position ] ... ] ;
////////////////////////////////////////////////////////////////////////////////

readStatement
    : 'READ' ID (',' ID)* read_from     ( 'BY' readPosition ( ',' readPosition )* )? ';'
    ;

 read_from :
    'FROM' ID
    ;

////////////////////////////////////////////////////////////////////////////////
// Position ::=
//   AbsolutePosition | RelativePosition | RST (Name§ErrorVariable-FIXED)
////////////////////////////////////////////////////////////////////////////////

readPosition :
      readWriteAbsolutePosition                             # readAbsPosition
    | readWriteRelativePosition                             # readRelPosition
    | 'RST' '(' ID ')'                                      # readRSTPosition
    ;

writePosition :
      readWriteAbsolutePosition                             # writeAbsPosition
    | readWriteRelativePosition                             # writeRelPosition
    | 'RST' '(' ID ')'                                      # writeRSTPosition
    ;

////////////////////////////////////////////////////////////////////////////////
// AbsolutePosition ::=
//   { COL | LINE } (Expression) |
//   POS ( [ [ Expression , ] Expression , ] Expression) | SOP ( [ [ Name , ] Name , ] Name)
////////////////////////////////////////////////////////////////////////////////

readWriteAbsolutePosition :
       'COL' '(' expression ')'                              # ReadWriteAbsolutePositionCOL
     | 'LINE' '(' expression ')'                             # ReadWriteAbsolutePositionLINE
     | 'POS' '(' ( (  expression ',' )? expression ',' )?
       expression ')'                                        # ReadWriteAbsolutePositionPOS
     | 'SOP' '(' ( ( ID ',' )? ID ',' )? ID ')'              # ReadWriteAbsolutePositionSOP
     ;


////////////////////////////////////////////////////////////////////////////////
// RelativePosition ::=
//   { X | SKIP | PAGE } [ (Expression) ] |
//   ADV ( [ [ Expression , ] Expression , ] Expression )
////////////////////////////////////////////////////////////////////////////////

readWriteRelativePosition :
      'X'     ( '(' expression ')' )?                         # readWriteRelativePositionX
    | 'SKIP'  ( '(' expression ')' )?                         # readWriteRelativePositionSKIP
    | 'PAGE'  ( '(' expression ')' )?                         # readWriteRelativePositionPAGE
    | 'ADV' '(' ( ( expression ',' )? expression ',' )?
      expression ')'                                          # readWriteRelativePositionADV
    ;

////////////////////////////////////////////////////////////////////////////////
// TakeStatement ::=
//   TAKE [ Name§Variable ] FROM Name§Dation
//     [ BY RST-S-CTRL-Format [ , RST-S-CTRL-Format ] ... ] ;
////////////////////////////////////////////////////////////////////////////////

takeStatement:
    'TAKE' ID?  takeFrom ( 'BY'  take_send_rst_s_ctrl_format ( ',' take_send_rst_s_ctrl_format)* )? ';'
    ;

takeFrom :
    'FROM' ID
    ;

////////////////////////////////////////////////////////////////////////////////
// SendStatement ::=
//   SEND [ Expression ] TO Name§Dation
//    [ BY RST-S-CTRL-Format [ , RST-S-CTRL-Format ] ... ] ;
////////////////////////////////////////////////////////////////////////////////

sendStatement :
    'SEND' expression? sendTo ( 'BY'  take_send_rst_s_ctrl_format ( ',' take_send_rst_s_ctrl_format)* )? ';'
    ;

sendTo :
    'TO' ID
    ;

////////////////////////////////////////////////////////////////////////////////
// RST-S-CTRL-Format ::=
//     RST ( Name§ErrorVariable-FIXED )
//   | S ( Name§Variable-FIXED )
//   | CONTROL ( Expression [ , Expression [ , Expression ] ] )
////////////////////////////////////////////////////////////////////////////////

take_send_rst_s_ctrl_format :
      'RST' '(' ID ')'                                  # take_send_rst_s_ctrl_format_RST
    | 'S' '(' ID ')'                                    # take_send_rst_s_ctrl_format_S
    | 'CONTROL' '(' expression (',' expression
        (',' expression)?)? ')'                         # take_send_rst_s_ctrl_format_CONTROL
    ;


////////////////////////////////////////////////////////////////////////////////

ID :   Letter ( Letter | Digit | '_' )* ;
IDENTIFIER :   Letter ( Letter | Digit | '_' )* ;

////////////////////////////////////////////////////////////////////////////////

type
    : simple_type
    | type_realtime_object
    | typeTime
    ;

////////////////////////////////////////////////////////////////////////////////
//  SimpleType ::=
//      TypeInteger | TypeFloatingPointNumber | TypeBitString | TypeCharacterString | TypeTime | TypeDuration
////////////////////////////////////////////////////////////////////////////////

simple_type
    : type_fixed
    | type_float
    | type_char
    | type_bit
    ;

////////////////////////////////////////////////////////////////////////////////

typeTime
    : type_clock
    | type_duration
    ;

////////////////////////////////////////////////////////////////////////////////

type_char : ( 'CHARACTER' | 'CHAR' ) ( '(' IntegerConstant ')' )?;
type_fixed: 'FIXED' ( '(' IntegerConstant ')' )?;
type_float: 'FLOAT' ( '(' IntegerConstant ')' )?;
type_duration: ( 'DURATION' | 'DUR' );
type_clock: 'CLOCK';
type_bit: 'BIT' ( '(' IntegerConstant ')' )?;

////////////////////////////////////////////////////////////////////////////////

type_realtime_object
    : 'SEMA'
    | 'BOLT'
    | 'IRPT'
    | 'INTERRUPT'
    | 'SIGNAL'
    ;

////////////////////////////////////////////////////////////////////////////////
//  DationSpecification ::=
//    { SPECIFY | SPC } IdentifierDenotation TypeDation [ GlobalAttribute ] ;
////////////////////////////////////////////////////////////////////////////////

dationSpecification
    : ( 'SPECIFY' | 'SPC' ) identifierDenotation specifyTypeDation globalAttribute? ';'
    ;

////////////////////////////////////////////////////////////////////////////////

specifyTypeDation
    : 'DATION' sourceSinkAttribute classAttribute
    ;

////////////////////////////////////////////////////////////////////////////////
// DationDeclaration ::=
//    {DECLARE | DCL} IdentifierDenotation TypeDation [GlobalAttribute] CREATED (Name§SystemDefDation);
////////////////////////////////////////////////////////////////////////////////

dationDeclaration
    : ( 'DECLARE' | 'DCL' ) identifierDenotation typeDation typology? accessAttribute? globalAttribute? 'CREATED' '(' ID  ')' ';'
    ;

////////////////////////////////////////////////////////////////////////////////
//  TypeDation ::=
//    DATION SourceSinkAttribute ClassAttribute [ Structure ] [ AccessAttribute ]
////////////////////////////////////////////////////////////////////////////////

typeDation
    : 'DATION' sourceSinkAttribute classAttribute
    ;

////////////////////////////////////////////////////////////////////////////////
//  SourceSinkAttribute ::=
//    IN | OUT | INOUT
////////////////////////////////////////////////////////////////////////////////

sourceSinkAttribute
    : 'IN'                  # sourceSinkAttributeIN
    | 'OUT'                 # sourceSinkAttributeOUT
    | 'INOUT'               # sourceSinkAttributeINOUT
    ;

////////////////////////////////////////////////////////////////////////////////

systemDation
    : 'SYSTEM'
    ;

////////////////////////////////////////////////////////////////////////////////
//  ClassAttribute ::=
//    [ SYSTEM ]                       /* system dation */
//    ALPHIC                       |   /* PUT/GET */
//    BASIC TypeOfTransmissionData |   /* TAKE/SEND */
//    TypeOfTransmissionData           /* READ/WRITE */
////////////////////////////////////////////////////////////////////////////////

classAttribute
    : systemDation? ( alphicDation | basicDation typeOfTransmissionData| typeOfTransmissionData)
    ;

////////////////////////////////////////////////////////////////////////////////

alphicDation
    : 'ALPHIC'
    ;
////////////////////////////////////////////////////////////////////////////////

basicDation
    : 'BASIC'
    ;

////////////////////////////////////////////////////////////////////////////////
//  TypeOfTransmissionData ::=
//    ALL | SimpleType | CompoundType
////////////////////////////////////////////////////////////////////////////////

typeOfTransmissionData
    : 'ALL'                     # typeOfTransmissionDataALL
    | simpleType                # typeOfTransmissionDataSimpleType
    | compoundType              # typeOfTransmissionDataCompoundType
    ;

////////////////////////////////////////////////////////////////////////////////
// AccessAttribute ::=
//  { DIRECT | FORWARD | FORBACK } [ NOCYCL | CYCLIC ] [ STREAM | NOSTREAM ]
////////////////////////////////////////////////////////////////////////////////

accessAttribute
    : ( 'DIRECT' | 'FORWARD' | 'FORBACK' ) ( 'NOCYCL' | 'CYCLIC' )? ( 'STREAM' | 'NOSTREAM' )?
    ;

////////////////////////////////////////////////////////////////////////////////
// Typology ::=
//      DIM( {⇤ |pi} [,pi[,pi]] ) [TFU[MAX]]
////////////////////////////////////////////////////////////////////////////////

typology :
    'DIM'
    '('
        dimension1 ( ( ',' dimension2 ) ( ',' dimension3 )? )?
    ')' ( ('TFU')? ('MAX')? )?
    ;

dimension1
    : '*'                      # dimension1Star
    | IntegerConstant          # dimension1Integer
    ;

dimension2
    : IntegerConstant          # dimension2Integer
    ;

dimension3
    : IntegerConstant          # dimension3Integer
    ;

typologyAttribute
    : ('TFU')? ('MAX')?
    ;


////////////////////////////////////////////////////////////////////////////////
// DimensionAttribute ::=
//  (BoundaryDenotation§FirstDimension [ , BoundaryDenotation§FurtherDimension ] ...)
////////////////////////////////////////////////////////////////////////////////

dimensionAttribute
    : '(' boundaryDenotation ( ',' boundaryDenotation )? ')'
    ;

boundaryDenotation
    : IntegerConstant
    ;

////////////////////////////////////////////////////////////////////////////////
//  CompoundType ::=
//    IO-Structure | Identifier§ForNewTypeFromSimpleTypes
////////////////////////////////////////////////////////////////////////////////

compoundType
    : ioStructure | ID
    ;

////////////////////////////////////////////////////////////////////////////////
//  IO-Structure ::=
//   STRUCT [ IO-StructureComponent [ , IO-StructureComponent ] ... ]
////////////////////////////////////////////////////////////////////////////////

ioStructure
    : 'STRUCT' ( ioStructureComponent ( ',' ioStructureComponent )* )?
    ;

////////////////////////////////////////////////////////////////////////////////
//   IO-StructureComponent := IdentifierDenotation
//     { SimpleType | IO-Structure | Identifier§ForNewTypeFromSimpleTypes }
////////////////////////////////////////////////////////////////////////////////

ioStructureComponent
    : identifierDenotation ( simpleType | ioStructure | ID )+
    ;

////////////////////////////////////////////////////////////////////////////////

expression
    : primaryExpression                                     # baseExpression
    | op=('*'|'/') expression                               # unaryMultiplicativeExpression
    | op='-' expression                                     # unarySubtractiveExpression
    | op='+' expression                                     # unaryAdditiveExpression
    | op='ATAN' expression                                  # atanExpression
    | op='COS' expression                                   # cosExpression
    | op='EXP' expression                                   # expExpression
    | op='LN' expression                                    # lnExpression
    | op='SIN' expression                                   # sinExpression
    | op='SQRT' expression                                  # sqrtExpression
    | op='TAN' expression                                   # tanExpression
    | op='TANH' expression                                  # tanhExpression
    | op='ABS' expression                                   # absExpression
    | op='SIGN' expression                                  # signExpression
    | op='SIZEOF' expression                                # sizeofExpression
    | op='ENTIER' expression                                # entierExpression
    | op='ROUND' expression                                 # roundExpression
    | op='NOT' expression                                   # notExpression
    | expression op='AND' expression                        # AndExpression
    | expression op='OR' expression                         # OrExpression
    | expression op='EXOR' expression                       # ExorExpression
    | expression op=('CAT'|'><') expression                 # catExpression
    | expression op=('CSHIFT'|'<>') expression              # cshiftExpression
    | expression op='SHIFT' expression                      # shiftExpression
    | expression op='**' <assoc=right> expression           # exponentiationExpression
    | expression op='*' expression                          # multiplicativeExpression
    | expression op='/' expression                          # divideExpression
    | expression op='//' expression                         # divideIntegerExpression
    | expression op='REM' expression                        # remainderExpression
    | expression op='FIT' expression                        # fitExpression
    | expression op='+' expression                          # additiveExpression
    | expression op='-' expression                          # subtractiveExpression
    | expression unaryLiteralExpression                     # unarySignedLiteralExpression
    | expression op=( '=='|'EQ') expression                 # eqRelationalExpression
    | expression op=( '/='|'NE') expression                 # neRelationalExpression
    | expression op=( '<'|'LT') expression                  # ltRelationalExpression
    | expression op=( '<='|'LE') expression                 # leRelationalExpression
    | expression op=( '>'|'GT') expression                  # gtRelationalExpression
    | expression op=( '>='|'GE') expression                 # geRelationalExpression
    | expression ('&&' expression)                          # conditionalAndExpression
    | expression ('||' expression)                          # conditionalOrExpression
    | op='NOW'                                              # nowFunction
    | op='DATE'                                             # dateFunction
    ;

////////////////////////////////////////////////////////////////////////////////

unaryLiteralExpression
    : (numericLiteralPositive | numericLiteralNegative) ( op=('*'|'/') unaryExpression)?
    ;

////////////////////////////////////////////////////////////////////////////////

unaryExpression
    : op=('+'|'-')? primaryExpression
    ;

////////////////////////////////////////////////////////////////////////////////

expressionList
    : expression (',' expression)*
    ;

////////////////////////////////////////////////////////////////////////////////

numericLiteral
    : numericLiteralUnsigned | numericLiteralPositive | numericLiteralNegative
    ;

////////////////////////////////////////////////////////////////////////////////

numericLiteralUnsigned
    : IntegerConstant
    ;

////////////////////////////////////////////////////////////////////////////////

numericLiteralPositive
    : IntegerConstant
    ;

////////////////////////////////////////////////////////////////////////////////

numericLiteralNegative
    : '-' IntegerConstant
    ;

////////////////////////////////////////////////////////////////////////////////

primaryExpression
	: '(' expression ')'
    | ID
    | ID listOfActualParameters?
    | literal
    | semaTry
    | monadicExplicitTypeConversionOperators
    ;

////////////////////////////////////////////////////////////////////////////////

// TODO Bug
// This statement:   y := SIN( COS 42+1) * EXP(1);
// compiles to:     _y = pearlrt::Float( (pearlrt::Float(( (pearlrt::Fixed<31>)42) + ((pearlrt::Fixed<31>)1)).cos()
//                           ) * pearlrt::Float((((pearlrt::Fixed<31>)1))).exp()).sin();
// which is wrong
// Seems to be a problem with operator precedence or parenthesis???

// monadicArithmeticOperators
//     : 'SQRT' expression                 # SQRT
//     | 'SIN' expression                  # SIN
//     | 'COS' expression                  # COS
//     | 'EXP' expression                  # EXP
//     | 'LN' expression                   # LN
//     | 'TAN' expression                  # TAN
//     | 'ATAN' expression                 # ATAN
//     | 'TANH' expression                 # TANH
//     ;

////////////////////////////////////////////////////////////////////////////////

monadicExplicitTypeConversionOperators
    : 'TOFIXED' expression               # TOFIXED
    | 'TOFLOAT' expression               # TOFLOAT
    | 'TOBIT'   expression               # TOBIT
    | 'TOCHAR'  expression               # TOCHAR
    | 'ENTIER'  expression               # ENTIER
    | 'ROUND'   expression               # ROUND
    | 'CONT'    expression               # CONT
    ;

////////////////////////////////////////////////////////////////////////////////

literal
    : IntegerConstant
    | FloatingPointConstant
    | ( StringLiteral | BitStringLiteral )
    | timeConstant
    | durationConstant
    ;

////////////////////////////////////////////////////////////////////////////////

IntegerConstant
	:	DecimalIntegerConstant
	;

////////////////////////////////////////////////////////////////////////////////

StringLiteral
    :  '\'' SCharSequence? '\''
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
SCharSequence
    :   SChar+
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
SChar
    :   ~['\\\r\n]
    |   EscapeSequence
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
EscapeSequence
    :   SimpleEscapeSequence
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
SimpleEscapeSequence
    :   '\\' ['"?abfnrtv\\]
    ;

////////////////////////////////////////////////////////////////////////////////

BitStringLiteral
	: '\'' B1Digit+ '\'' ( 'B' | 'B1' )
    | '\'' B2Digit+ '\'' 'B2'
    | '\'' B3Digit+ '\'' 'B3'
    | '\'' B4Digit+ '\'' 'B4'
	;

////////////////////////////////////////////////////////////////////////////////

fragment
DecimalIntegerConstant
	:	DecimalNumeral
	;

////////////////////////////////////////////////////////////////////////////////

fragment
DecimalNumeral
	:	'0'+
	|	NonZeroDigit Digits?
	;

////////////////////////////////////////////////////////////////////////////////

fragment
Digits
	:	Digit+
	;

////////////////////////////////////////////////////////////////////////////////

fragment
Digit
	:	'0'
	|   NonZeroDigit
	;

////////////////////////////////////////////////////////////////////////////////

fragment
NonZeroDigit
	:	[1-9]
	;

////////////////////////////////////////////////////////////////////////////////

fragment
Letter : [a-zA-Z] ;

////////////////////////////////////////////////////////////////////////////////

fragment
Sign
    :   '+' | '-'
    ;

////////////////////////////////////////////////////////////////////////////////
//  Constant ::= Integer
//      | FloatingPointNumber | BitStringConstant
//      | TimeConstant
//      | DurationConstant
//      | NIL
////////////////////////////////////////////////////////////////////////////////

constant :
      ('+'|'-')? ( IntegerConstant | FloatingPointConstant )
    | timeConstant
    | durationConstant
    | BitStringLiteral
    | StringLiteral
    | 'NIL'
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
B1Digit
    : '0' | '1'
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
B2Digit
    : '0' | '1' | '2' | '3'
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
B3Digit
    : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7'
    ;

////////////////////////////////////////////////////////////////////////////////

fragment
B4Digit
    : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
    ;

////////////////////////////////////////////////////////////////////////////////
// TimeConstant ::=
//   Digit ... : Digit ... : Digit ... [ . Digit ... ]
//     : timeHour ':' timeMinute ':' timeSeconds
// Digit+ ('.' Digit+)?
// ':'  IntegerConstant ':' FloatingPointNumberWithoutPrecisionAndExponent
////////////////////////////////////////////////////////////////////////////////

timeConstant
    : IntegerConstant ':' IntegerConstant ':' ( IntegerConstant | FloatingPointConstant )
    ;

////////////////////////////////////////////////////////////////////////////////

durationConstant
    : hours  minutes? seconds?
    | minutes seconds?
    | seconds
    ;


////////////////////////////////////////////////////////////////////////////////

hours
    : IntegerConstant 'HRS'
    ;

////////////////////////////////////////////////////////////////////////////////

minutes
    : IntegerConstant 'MIN'
    ;

////////////////////////////////////////////////////////////////////////////////

seconds
    : ( IntegerConstant | FloatingPointConstant ) 'SEC'
    ;

////////////////////////////////////////////////////////////////////////////////
// FloatingPointNumber ::= FloatingPointNumberWithoutPrecision [ ( Precision ) ]
////////////////////////////////////////////////////////////////////////////////

FloatingPointConstant
    : FloatingPointNumberWithoutPrecision ( '(' IntegerConstant ')' )?
    ;


////////////////////////////////////////////////////////////////////////////////

FloatingPointNumberPrecision
    : IntegerConstant
    ;


////////////////////////////////////////////////////////////////////////////////
// FloatingPointNumberWithoutPrecision ::=
//      {Digit... . [Digit... ]|. Digit... }[Exponent] | Digit ... Exponent
////////////////////////////////////////////////////////////////////////////////

FloatingPointNumberWithoutPrecision
    : ('+'|'-')? ( Digit+ '.' ( Digit+)? | '.' Digit+ ) Exponent?
    | Digit+ Exponent
    ;

////////////////////////////////////////////////////////////////////////////////
// Exponent ::=
//      E [ + | - ] Digit ...
////////////////////////////////////////////////////////////////////////////////

fragment
Exponent
    : 'E' ( '+' | '-' )? Digit+
    ;

////////////////////////////////////////////////////////////////////////////////

FloatingPointNumberWithoutPrecisionAndExponent
    : Digit+ '.' ( Digit+)?
    ;

////////////////////////////////////////////////////////////////////////////////

cpp_inline
    : ( '__cpp__' | '__cpp' )  '(' StringLiteral+ ')' ';'
    ;

////////////////////////////////////////////////////////////////////////////////
// LengthDefinition::=
//      LENGTH { { FIXED | FLOAT } (precision)
//               | { BIT | CHARACTER | CHAR } (length) };
//
// Example:
//      PROBLEM;
//          LENGTH FIXED(15);
//          LENGTH FLOAT(53);
//
//          DCL A FIXED,        /* A is of type FIXED(15) */
//              X FLOAT,        /* X is of type FLOAT(53) */
//              Y FLOAT(23);    /* Y is of type FLOAT(23) */
//
////////////////////////////////////////////////////////////////////////////////


length_definition
    : 'LENGTH' (( 'FIXED'  | 'FLOAT' )'(' precision ')' )
    | (( 'BIT' | 'CHARACTER' | 'CHAR' ) '(' length ')' ) ';'
    ;

////////////////////////////////////////////////////////////////////////////////

 precision
    : IntegerConstant
    ;

////////////////////////////////////////////////////////////////////////////////

 length
     : IntegerConstant
     ;

////////////////////////////////////////////////////////////////////////////////

//
// Whitespace and comments
//

////////////////////////////////////////////////////////////////////////////////

BlockComment
    :   '/*' .*? '*/'
        -> channel(HIDDEN)
    ;

////////////////////////////////////////////////////////////////////////////////

LineComment
    :   '!' ~[\r\n]*
        -> channel(HIDDEN)
    ;

////////////////////////////////////////////////////////////////////////////////

Whitespace
    :   [ \t]+
        -> channel(HIDDEN)
    ;

////////////////////////////////////////////////////////////////////////////////

Newline
    :   (   '\r' '\n'?
        |   '\n'
        )
        -> channel(HIDDEN)
    ;

////////////////////////////////////////////////////////////////////////////////

// handle characters which failed to match any other token
ErrorCharacter :
    .
    ;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////// END OF FILE /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

