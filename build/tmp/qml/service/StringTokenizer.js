
/*
  Utiity functions used to tokenize the text inserted in the Clipboard.
  The separators used to create the tokens are the ones chosen by the user from the ones available (comma, space, new line)
*/

   /* tokenize the input text using the provided separator */
  function tokenize(text, separators) {

        var lastPos = 0;
        
        /* produced rtoken to return */
        var tokens = [];
        if(text) {
            for(var c = 0; c < text.length; c++) {
                var ch = text.charAt(c);
                if(isSeparator(ch, separators)) {
                    var token = text.substring(lastPos, c);
                    addToken(token, tokens, separators);
                    lastPos = c + 1;
                }
            }
            token = text.substring(lastPos);
            addToken(token, tokens, separators);
        }
        return tokens;
    }

    function isSeparator(ch, separators) {
        for(var s = 0; s < separators.length; s++) {
            if(separators[s] === ch) {
                return true;
            }
        }
        return false;
    }

    function addToken(token, tokens, separators) {
        token = token.trim();
        if(token.length > 0 && !isSeparator(token, separators)) {
            tokens.push(token);
        }
    }
