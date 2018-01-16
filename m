Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:34060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbeAPRTQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 12:19:16 -0500
Date: Tue, 16 Jan 2018 12:19:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com
Subject: Re: [PATCH v3 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180116121913.42d09aea@gandalf.local.home>
In-Reply-To: <20180116074744.5522-2-vladislav.valtchev@gmail.com>
References: <20180116074744.5522-1-vladislav.valtchev@gmail.com>
        <20180116074744.5522-2-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Jan 2018 09:47:42 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

> +	errno = 0;
> +
> +	/* Read an integer from buf ignoring any non-digit trailing characters. */
> +	num = strtol(buf, NULL, 10);
> +
> +	/* strtol() returned 0: we have to check for errors */
> +	if (!num && (errno == EINVAL || errno == ERANGE))
> +		return -1;

Repeating again here. According to the man page of strtol():

RETURN VALUE
       The  strtol() function returns the result of the conversion, unless the
       value would underflow or overflow.  If an  underflow  occurs,  strtol()
       returns  LONG_MIN.   If  an overflow occurs, strtol() returns LONG_MAX.
       In both cases, errno is set to ERANGE.  Precisely the  same  holds  for
       strtoll()  (with  LLONG_MIN  and  LLONG_MAX  instead  of  LONG_MIN  and
       LONG_MAX).

and this:

       The implementation may also set errno to EINVAL in case  no  conversion
       was performed (no digits seen, and 0 returned).

Thus, !num is not enough. The example in the man page has:

           errno = 0;    /* To distinguish success/failure after call */
           val = strtol(str, &endptr, base);

           /* Check for various possible errors */

           if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
                   || (errno != 0 && val == 0)) {
               perror("strtol");
               exit(EXIT_FAILURE);
           }

Let's follow this.

-- Steve
