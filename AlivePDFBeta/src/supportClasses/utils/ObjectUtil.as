////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package supportClasses.utils
{
import flash.utils.Dictionary;

/**
 *  The ObjectUtil class is an all-static class with methods for
 *  working with Objects within Flex.
 *  You do not create instances of ObjectUtil;
 *  instead you simply call static methods such as the 
 *  <code>ObjectUtil.isSimple()</code> method.
 *  
 */
public class ObjectUtil
{
    /**
    *  Array of properties to exclude from debugging output.
    *  
    */
    private static var defaultToStringExcludes:Array = ["password", "credentials"];

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------


        
    /**
     *  Pretty-prints the specified Object into a String.
     *  All properties will be in alpha ordering.
     *  Each object will be assigned an id during printing;
     *  this value will be displayed next to the object type token
     *  preceded by a '#', for example:
     *
     *  <pre>
     *  (mx.messaging.messages::AsyncMessage)#2.</pre>
     *
     *  <p>This id is used to indicate when a circular reference occurs.
     *  Properties of an object that are of the <code>Class</code> type will
     *  appear only as the assigned type.
     *  For example a custom definition like the following:</p>
     *
     *  <pre>
     *    public class MyCustomClass {
     *      public var clazz:Class;
     *    }</pre>
     * 
     *  <p>With the <code>clazz</code> property assigned to <code>Date</code>
     *  will display as shown below:</p>
     * 
     *  <pre>
     *   (somepackage::MyCustomClass)#0
     *      clazz = (Date)</pre>
     *
     *  @param obj Object to be pretty printed.
     * 
     *  @param namespaceURIs Array of namespace URIs for properties 
     *  that should be included in the output.
     *  By default only properties in the public namespace will be included in
     *  the output.
     *  To get all properties regardless of namespace pass an array with a 
     *  single element of "*".
     * 
     *  @param exclude Array of the property names that should be 
     *  excluded from the output.
     *  Use this to remove data from the formatted string.
     * 
     *  @return String containing the formatted version
     *  of the specified object.
     *
     *  @example
     *  <pre>
     *  // example 1
     *  var obj:AsyncMessage = new AsyncMessage();
     *  obj.body = [];
     *  obj.body.push(new AsyncMessage());
     *  obj.headers["1"] = { name: "myName", num: 15.3};
     *  obj.headers["2"] = { name: "myName", num: 15.3};
     *  obj.headers["10"] = { name: "myName", num: 15.3};
     *  obj.headers["11"] = { name: "myName", num: 15.3};
     *  trace(ObjectUtil.toString(obj));
     *
     *  // will output to flashlog.txt
     *  (mx.messaging.messages::AsyncMessage)#0
     *    body = (Array)#1
     *      [0] (mx.messaging.messages::AsyncMessage)#2
     *        body = (Object)#3
     *        clientId = (Null)
     *        correlationId = ""
     *        destination = ""
     *        headers = (Object)#4
     *        messageId = "378CE96A-68DB-BC1B-BCF7FFFFFFFFB525"
     *        sequenceId = (Null)
     *        sequencePosition = 0
     *        sequenceSize = 0
     *        timeToLive = 0
     *        timestamp = 0
     *    clientId = (Null)
     *    correlationId = ""
     *    destination = ""
     *    headers = (Object)#5
     *      1 = (Object)#6
     *        name = "myName"
     *        num = 15.3
     *      10 = (Object)#7
     *        name = "myName"
     *        num = 15.3
     *      11 = (Object)#8
     *        name = "myName"
     *        num = 15.3
     *      2 = (Object)#9
     *        name = "myName"
     *        num = 15.3
     *    messageId = "1D3E6E96-AC2D-BD11-6A39FFFFFFFF517E"
     *    sequenceId = (Null)
     *    sequencePosition = 0
     *    sequenceSize = 0
     *    timeToLive = 0
     *    timestamp = 0
     *
     *  // example 2 with circular references
     *  obj = {};
     *  obj.prop1 = new Date();
     *  obj.prop2 = [];
     *  obj.prop2.push(15.2);
     *  obj.prop2.push("testing");
     *  obj.prop2.push(true);
     *  obj.prop3 = {};
     *  obj.prop3.circular = obj;
     *  obj.prop3.deeper = new ErrorMessage();
     *  obj.prop3.deeper.rootCause = obj.prop3.deeper;
     *  obj.prop3.deeper2 = {};
     *  obj.prop3.deeper2.deeperStill = {};
     *  obj.prop3.deeper2.deeperStill.yetDeeper = obj;
     *  trace(ObjectUtil.toString(obj));
     *
     *  // will output to flashlog.txt
     *  (Object)#0
     *    prop1 = Tue Apr 26 13:59:17 GMT-0700 2005
     *    prop2 = (Array)#1
     *      [0] 15.2
     *      [1] "testing"
     *      [2] true
     *    prop3 = (Object)#2
     *      circular = (Object)#0
     *      deeper = (mx.messaging.messages::ErrorMessage)#3
     *        body = (Object)#4
     *        clientId = (Null)
     *        code = (Null)
     *        correlationId = ""
     *        destination = ""
     *        details = (Null)
     *        headers = (Object)#5
     *        level = (Null)
     *        message = (Null)
     *        messageId = "14039376-2BBA-0D0E-22A3FFFFFFFF140A"
     *        rootCause = (mx.messaging.messages::ErrorMessage)#3
     *        sequenceId = (Null)
     *        sequencePosition = 0
     *        sequenceSize = 0
     *        timeToLive = 0
     *        timestamp = 0
     *      deeper2 = (Object)#6
     *        deeperStill = (Object)#7
     *          yetDeeper = (Object)#0
     * 
     * // example 3 with Dictionary
     * var point:Point = new Point(100, 100);
     * var point2:Point = new Point(100, 100);
     * var obj:Dictionary = new Dictionary();
     * obj[point] = "point";
     * obj[point2] = "point2";
     * obj["1"] = { name: "one", num: 1};
     * obj["two"] = { name: "2", num: 2};
     * obj[3] = 3;
     * trace(ObjectUtil.toString(obj));
     * 
     * // will output to flashlog.txt
     * (flash.utils::Dictionary)#0
     *   {(flash.geom::Point)#1
     *     length = 141.4213562373095
     *     x = 100
     *     y = 100} = "point2"
     *   {(flash.geom::Point)#2
     *     length = 141.4213562373095
     *     x = 100
     *     y = 100} = "point"
     *   {1} = (Object)#3
     *     name = "one"
     *     num = 1
     *   {3} = 3
     *   {"two"} = (Object)#4
     *     name = "2"
     *     num = 2
     * 
     * </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function toString(value:Object, 
                                    namespaceURIs:Array = null, 
                                    exclude:Array = null):String
    {
        if (exclude == null)
        {
            exclude = defaultToStringExcludes;
        }
        
        refCount = 0;
        return internalToString(value, 0, null, namespaceURIs, exclude);
    }
    
    /**
     *  This method cleans up all of the additional parameters that show up in AsDoc
     *  code hinting tools that developers shouldn't ever see.
     *  @private
     */
    private static function internalToString(value:Object, 
                                             indent:int = 0,
                                             refs:Dictionary= null, 
                                             namespaceURIs:Array = null, 
                                             exclude:Array = null):String
    {
        var str:String;
        var type:String = value == null ? "null" : typeof(value);
        switch (type)
        {
            case "boolean":
            case "number":
            {
                return value.toString();
            }

            case "string":
            {
                return "\"" + value.toString() + "\"";
            }

            case "object":
            {
                return "[object]";
            }
            case "xml":
            {
                return value.toXMLString();
            }
            default:
            {
                return "(" + type + ")";
            }
        }
        
        return "(unknown)";
    }

    /**
     *  @private
     *  This method will append a newline and the specified number of spaces
     *  to the given string.
     */
    private static function newline(str:String, n:int = 0):String
    {
        var result:String = str;
        result += "\n";

        for (var i:int = 0; i < n; i++)
        {
            result += " ";
        }
        return result;
    }


    /**
     * @private
     */
    private static var refCount:int = 0;

}

}
