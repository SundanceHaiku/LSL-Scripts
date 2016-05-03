// :CATEGORY:Viewer 2
// :NAME:SVG_Scalable_Vector_Graphics_in_Sha
// :AUTHOR:Pavcules Superior
// :CREATED:2010-09-02 12:04:07.130
// :EDITED:2013-09-18 15:39:05
// :ID:853
// :NUM:1183
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
Example website: http://tutorials.jenkov.com/svg/index.html
// :CODE:
// SVG on a Prim
// Developed by: Pavcules Superior
// Developed on: March 2010

string g_strNotecardName;   
string g_strNotecardText;
integer g_intNotecardLine = 0;        
key g_keyNotecardQueryID; 
key g_keyURLRequestID;


// Start reading the notecard text.
ReadNotecardText()
{
    llOwnerSay("Reading Notecard...please wait.");
    
    g_intNotecardLine = 0;    
    g_strNotecardText = "";    
    g_strNotecardName = llGetInventoryName(INVENTORY_NOTECARD, 0);
    g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);   
  
    // Change the URL
    llSetPrimMediaParams(0,[ PRIM_MEDIA_CURRENT_URL, "data:text/plain,Loading Page...Please Wait..."  + (string)llGetUnixTime()]);
     
}


default
{
    state_entry()
    {
        
        ReadNotecardText();

        g_keyURLRequestID = llRequestURL();

    }
    
    changed(integer change)
    {
        // If the inventory is updated, read the notecard data again.        
        if(change & CHANGED_INVENTORY)
        {
              ReadNotecardText();
        }       
    }
    
    
    dataserver(key query_id, string data) 
    {
        if (query_id == g_keyNotecardQueryID) 
        {
            if (data != EOF)
            {    
                // Store the text.
                g_strNotecardText += data;
                
                // Read next notecard line.
                ++g_intNotecardLine;
                g_keyNotecardQueryID = llGetNotecardLine(g_strNotecardName, g_intNotecardLine);
            }
            else
            {
                // We have reached the end of the notecard.
                llOwnerSay("Size: " + (string)llStringLength(g_strNotecardText));
                llOwnerSay("Rendering Media image...please wait.");
                
                // Refresh the URL again by setting a random URL parameter value.
                llSetPrimMediaParams(0,
                    [PRIM_MEDIA_AUTO_PLAY,TRUE,
                     PRIM_MEDIA_CURRENT_URL,"data:image/svg+xml," + g_strNotecardText,
                     PRIM_MEDIA_HEIGHT_PIXELS,1024,
                     PRIM_MEDIA_WIDTH_PIXELS,1024]);                  
                    
            }
        }
    }    
    
}