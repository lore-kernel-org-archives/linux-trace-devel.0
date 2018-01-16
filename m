Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35598 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeAPOrh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 09:47:37 -0500
Message-ID: <1516114053.12026.20.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jan 2018 16:47:33 +0200
In-Reply-To: <20180112101323.547a026e@gandalf.local.home>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
         <20171221152520.25867-2-vladislav.valtchev@gmail.com>
         <20180112101323.547a026e@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 2018-01-12 at 10:13 -0500, Steven Rostedt wrote:
> > +
> > +	/* We assume that the file is never empty we got no errors. */
> 
> The above comment does not parse.

OK, I just removed it.

> 
> > +	if (n <= 0)
> >  		die("error reading %s", PROC_FILE);
> >  
> > -	return buf[0];
> > +	/* Does this file have more than 63 characters?? */
> > +	if (n >= sizeof(buf))
> > +		return -1;
> 
> We need to close fd before returning, otherwise we leak a file
> descriptor.

Oops, you're totally right.

> 
> We can move the close right after the read up above.
> 

Yep.

> > +
> > +	/* n is guaranteed to be in the range [1, sizeof(buf)-1]. */
> > +	buf[n] = 0;
> > +	close(fd);
> > +
> > +	errno = 0;
> > +
> > +	/* Read an integer from buf ignoring any non-digit trailing characters. */
> 
> We don't really need to comment what strtol() does ;-) That's what man
> pages are for.
> 

Alright.

> > +	num = strtol(buf, NULL, 10);
> > +
> > +	/* strtol() returned 0: we have to check for errors */
> 
> Actually, a better comment is, why would strtol return zero and this
> not be an error?

I don't understand: I'm checking exactly the case when strtol() returned 0
and that might be an error. It's not sure that there's an error, but there might be.

It would be strange for me to read:

"why would strtol return zero and this not be an error?"
and see an IF statement which in the true-path returns -1.


> > +	if (num > INT_MAX || num < INT_MIN)
> > +		return -1; /* the number is good but does not fit in 'int' */
> 
> Don't need the comment after the above return. The INT_MAX and INT_MIN
> are self describing.

OK

> 
> Don't add a new line here. It's common to have the error check
> immediately after the function.

OK

> 
> >  	if (fd < 0)
> >  		die("writing %s", PROC_FILE);
> 
> If you want a new line, you can add it here.
> 
> > -	buf[0] = val;
> > +	buf[0] = new_status + '0';
> 
> If you are paranoid, we can make new_status unsigned int, or even
> unsigned char, and add at the beginning of the function:
> 
> 	if (new_status > 9) {
> 		warning("invalid status %d\n", new_status);
>		return;
>	}


The problem with that is that we agreed the value in the proc file
might also be negative. That's why new_status should be an int.
So, what a check like that:

	if (new_status < 0 || new_status > 9) {
		warning("invalid status %d\n", new_status);
		return;
	}



> 
> >  	n = write(fd, buf, 1);
> >  	if (n < 0)
> >  		die("writing into %s", PROC_FILE);
> > @@ -88,12 +131,12 @@ static void start_stop_trace(char val)
> >  
> >  static void start_trace(void)
> >  {
> > -	start_stop_trace('1');
> > +	change_stack_tracer_status(1);
> >  }
> >  
> >  static void stop_trace(void)
> >  {
> > -	start_stop_trace('0');
> > +	change_stack_tracer_status(0);
> >  }
> >  
> >  static void reset_trace(void)
> > @@ -123,8 +166,12 @@ static void read_trace(void)
> >  	char *buf = NULL;
> >  	size_t n;
> >  	int r;
> > +	int status;
> 
> Remember, upside down x-mas trees.

Sure.

-- 
Vladislav Valtchev
VMware Open Source Technology Center
