Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750811AbeAPQ1N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:27:13 -0500
Date: Tue, 16 Jan 2018 11:27:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180116112710.283b90f4@gandalf.local.home>
In-Reply-To: <1516114053.12026.20.camel@gmail.com>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
        <20171221152520.25867-2-vladislav.valtchev@gmail.com>
        <20180112101323.547a026e@gandalf.local.home>
        <1516114053.12026.20.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Jan 2018 16:47:33 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:

> 
> > > +	num = strtol(buf, NULL, 10);
> > > +
> > > +	/* strtol() returned 0: we have to check for errors */  
> > 
> > Actually, a better comment is, why would strtol return zero and this
> > not be an error?  
> 
> I don't understand: I'm checking exactly the case when strtol() returned 0
> and that might be an error. It's not sure that there's an error, but there might be.
> 
> It would be strange for me to read:
> 
> "why would strtol return zero and this not be an error?"
> and see an IF statement which in the true-path returns -1.

:-)  That was totally lost in translation. :-)

No, I didn't mean to have a comment literally saying "why would strtol
return zero and this not be an error", I meant for the comment to
explain it.

Actually, looking at the man page which states:

====
RETURN VALUE
       The  strtol() function returns the result of the conversion, unless the
       value would underflow or overflow.  If an  underflow  occurs,  strtol()
       returns  LONG_MIN.   If  an overflow occurs, strtol() returns LONG_MAX.
       In both cases, errno is set to ERANGE.  Precisely the  same  holds  for
       strtoll()  (with  LLONG_MIN  and  LLONG_MAX  instead  of  LONG_MIN  and
       LONG_MAX).
====

Which means that zero isn't enough to check.

It also shows the following example:

====
           errno = 0;    /* To distinguish success/failure after call */
           val = strtol(str, &endptr, base);

           /* Check for various possible errors */

           if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
                   || (errno != 0 && val == 0)) {
               perror("strtol");
               exit(EXIT_FAILURE);
           }
====

I say we simply remove the comment. Or say what the man page example
says:

	/* Check for various possible errors */

and leave it at that.


> >   
> > >  	if (fd < 0)
> > >  		die("writing %s", PROC_FILE);  
> > 
> > If you want a new line, you can add it here.
> >   
> > > -	buf[0] = val;
> > > +	buf[0] = new_status + '0';  
> > 
> > If you are paranoid, we can make new_status unsigned int, or even
> > unsigned char, and add at the beginning of the function:
> > 
> > 	if (new_status > 9) {
> > 		warning("invalid status %d\n", new_status);
> >		return;
> >	}  
> 
> 
> The problem with that is that we agreed the value in the proc file
> might also be negative. That's why new_status should be an int.
> So, what a check like that:
> 
> 	if (new_status < 0 || new_status > 9) {
> 		warning("invalid status %d\n", new_status);
> 		return;
> 	}

Sure it could be negative. The point was, you don't want it to be if
you do:

	buf[0] = new_status + '0';

As that will break if new_status is negative or greater than 9.

Also, whether you use unsigned, or do the above, they both have the
same result. A negative produces a warning. Which is fine. As long as
it doesn't kill the program. It's only an implementation detail.

That is, using unsigned char as new_status, and checking

	if (new_status > 9)

Is no different than using int and checking

	if (new_status < 0 || new_status > 9)

except that you use more instructions to accomplish the same thing.


-- Steve
