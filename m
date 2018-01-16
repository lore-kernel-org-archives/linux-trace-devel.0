Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35064 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeAPTKj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 14:10:39 -0500
Message-ID: <1516129836.4042.23.camel@gmail.com>
Subject: Re: [PATCH v3 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com
Date: Tue, 16 Jan 2018 21:10:36 +0200
In-Reply-To: <20180116121913.42d09aea@gandalf.local.home>
References: <20180116074744.5522-1-vladislav.valtchev@gmail.com>
         <20180116074744.5522-2-vladislav.valtchev@gmail.com>
         <20180116121913.42d09aea@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 2018-01-16 at 12:19 -0500, Steven Rostedt wrote:
> On Tue, 16 Jan 2018 09:47:42 +0200
> "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:
> 
> > +	errno = 0;
> > +
> > +	/* Read an integer from buf ignoring any non-digit trailing characters. */
> > +	num = strtol(buf, NULL, 10);
> > +
> > +	/* strtol() returned 0: we have to check for errors */
> > +	if (!num && (errno == EINVAL || errno == ERANGE))
> > +		return -1;
> 
> Repeating again here. According to the man page of strtol():

v3 addresses only the comments for patch 3/3.
I'm sorry for that. All the other comments will be addressed in v4.

> 
> RETURN VALUE
>        The  strtol() function returns the result of the conversion, unless the
>        value would underflow or overflow.  If an  underflow  occurs,  strtol()
>        returns  LONG_MIN.   If  an overflow occurs, strtol() returns LONG_MAX.
>        In both cases, errno is set to ERANGE.  Precisely the  same  holds  for
>        strtoll()  (with  LLONG_MIN  and  LLONG_MAX  instead  of  LONG_MIN  and
>        LONG_MAX).
> 
> and this:
> 
>        The implementation may also set errno to EINVAL in case  no  conversion
>        was performed (no digits seen, and 0 returned).
> 
> Thus, !num is not enough. The example in the man page has:
> 
>            errno = 0;    /* To distinguish success/failure after call */
>            val = strtol(str, &endptr, base);
> 
>            /* Check for various possible errors */
> 
>            if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
>                    || (errno != 0 && val == 0)) {
>                perror("strtol");
>                exit(EXIT_FAILURE);
>            }
> 
> Let's follow this.
> 
> -- Steve

Sure, I thought that:

	errno = 0;
	num = strtol(buf, NULL, 10);

	/* strtol() returned 0: we have to check for errors */
	if (!num && (errno == EINVAL || errno == ERANGE))
		return -1;

	if (num > INT_MAX || num < INT_MIN)
		return -1;

covered all the cases because the case:
(val == LONG_MAX || val == LONG_MIN)

is covered by: if (num > INT_MAX || num < INT_MIN)
[no matter the errno]

but that's not true for 32 bit systems where sizeof(long) == sizeof(int).
It had to be: if (num >= INT_MAX || num <= INT_MIN), but in that
case it would exclude two valid int32 values.

Therefore, let's go with:
	if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
            || (errno != 0 && val == 0))


Just let me keep also the following check:

	if (num > INT_MAX || num < INT_MIN)
		return -1;

since [INT_MIN, INT_MAX] is a subset of [LONG_MIN, LONG_MAX].

Vlad


-- 
Vladislav Valtchev
VMware Open Source Technology Center
