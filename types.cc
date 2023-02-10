// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>
#include <iostream>
using namespace std;
#include "types.h"
#include "listing.h"
void checkAssignment(Types lValue, Types rValue, string message)
{
	if(rValue == MISMATCH)
		return;
	if(lValue == BOOL_TYPE && rValue != BOOL_TYPE || lValue!=BOOL_TYPE && rValue == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
	else if(lValue == INT_TYPE && rValue == REAL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
	}
}
Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
	{
		return REAL_TYPE;
	}
	return INT_TYPE;
}
Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
	return BOOL_TYPE;
}
Types checkRemainder(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
		return MISMATCH;
	}
	return INT_TYPE;
}
Types checkIfThen(Types expression, Types left, Types right)
{
	if(expression!= BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "If Expression Must BE Boolean");
		return MISMATCH;
	}
	if(left!=right)
	{
		appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
		return MISMATCH;
	}
	return left;
}
Types checkNegation(Types right)
{
	if (right !=BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
	return BOOL_TYPE;
}
Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}
Types checkExpression(Types expression)
{
	if(expression!=INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case expression Not Integer ");
		return MISMATCH;
	}
	return INT_TYPE;
}
Types checkCases(Types case_, Types cases)
{
	if (cases != INT_TYPE)
	{
		if( cases != NAN_TYPE && case_ != cases)
		{
			appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
			return MISMATCH;
		}
	}
	if (case_ != INT_TYPE)
	{
		if ((cases != NAN_TYPE || cases != INT_TYPE) && case_ == cases)
		{
			return cases;
		}
		return case_;
	}
	return NAN_TYPE;
}
Types checkReturns(Types cases, Types others)
{
	if(cases!=NAN_TYPE || cases != INT_TYPE)
	{
		return cases;
	}
	return INT_TYPE;
}
