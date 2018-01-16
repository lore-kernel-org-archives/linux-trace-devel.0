Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:37170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbeAPRaa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 12:30:30 -0500
Date: Tue, 16 Jan 2018 12:30:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com
Subject: Re: [PATCH v3 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180116123027.397e732f@gandalf.local.home>
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

> diff --git a/trace-stack.c b/trace-stack.c
> index aa79ae3..c1058ca 100644
> --- a/trace-stack.c
> +++ b/trace-stack.c
> @@ -20,6 +20,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <limits.h>
>  #include <getopt.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -49,37 +50,79 @@ static void test_available(void)
>  		die("stack tracer not configured on running kernel");
>  }
>  
> -static char read_proc(void)
> +/*
> + * Returns:
> + *   -1 - Something went wrong
> + *    0 - File does not exist (stack tracer not enabled)
> + *    1 - Success
> + */
> +static int read_proc(int *status)
>  {
> -	char buf[1];
> +	struct stat stat_buf;
> +	char buf[64];
> +	long num;
>  	int fd;
>  	int n;
>  
> +	if (stat(PROC_FILE, &stat_buf) < 0) {
> +		/* stack tracer not configured on running kernel */
> +		*status = 0; /* not configured means disabled */
> +		return 0;
> +	}
> +
>  	fd = open(PROC_FILE, O_RDONLY);
> -	if (fd < 0)
> -		die("reading %s", PROC_FILE);
> -	n = read(fd, buf, 1);
> -	close(fd);
> -	if (n != 1)
> +
> +	if (fd < 0) {
> +		/* we cannot open the file: likely a permission problem. */
> +		return -1;
> +	}

Let's follow Linux coding style. The comment is obvious and can be
removed, and we can remove the braces.

	if (fd < 0)
		return -1;

> +
> +	n = read(fd, buf, sizeof(buf));
> +
> +	/* We assume that the file is never empty we got no errors. */
> +	if (n <= 0)
>  		die("error reading %s", PROC_FILE);
>  
> -	return buf[0];
> +	/* Does this file have more than 63 characters?? */

The comment is too verbose, and not needed.

> +	if (n >= sizeof(buf))
> +		return -1;
> +
> +	/* n is guaranteed to be in the range [1, sizeof(buf)-1]. */

The comment is not needed. It would be a bug if it were not true, and
the code directly above the comment shows this guarantee.

> +	buf[n] = 0;
> +	close(fd);
> +
> +	errno = 0;
> +
> +	/* Read an integer from buf ignoring any non-digit trailing characters. */

Don't need to describe what strtol() does. Remove the comment please.

> +	num = strtol(buf, NULL, 10);
> +
> +	/* strtol() returned 0: we have to check for errors */

Already commented about this code in my last email.

> +	if (!num && (errno == EINVAL || errno == ERANGE))
> +		return -1;
> +
> +	if (num > INT_MAX || num < INT_MIN)
> +		return -1; /* the number is good but does not fit in 'int' */

Comment is redundant and unnecessary, please remove it.

Comments are good, but not if they are at the level of describing the
code for a beginner programmer. That is, if the code isn't obvious what
it is doing, it should be commented. But comments that describe the
definition of the code end up causing more noise than being helpful.


> +
> +	*status = num;
> +	return 1; /* full success */
>  }
>  
> -static void start_stop_trace(char val)
> +/* NOTE: this implementation only accepts new_status in the range [0..9]. */

For example, the above comment is good. It explicitly states that this
function requires the parameter new_status be in the range of 0-9, and
a reviewer or new developer doesn't have to go read the function to
figure that out.


> +static void change_stack_tracer_status(int new_status)
>  {
>  	char buf[1];
> +	int status;
>  	int fd;
>  	int n;
>  

Should enforce that new_status is between 0 and 9, by one of the
methods I discussed in the other email.

-- Steve

> -	buf[0] = read_proc();
> -	if (buf[0] == val)
> -		return;
> +	if (read_proc(&status) > 0 && status == new_status)
> +		return; /* nothing to do */
>  
>  	fd = open(PROC_FILE, O_WRONLY);
> +
>  	if (fd < 0)
>  		die("writing %s", PROC_FILE);
> -	buf[0] = val;
> +	buf[0] = new_status + '0';
>  	n = write(fd, buf, 1);
>  	if (n < 0)
>  		die("writing into %s", PROC_FILE);
> @@ -88,12 +131,12 @@ static void start_stop_trace(char val)
>  
>  static void start_trace(void)
>  {
> -	start_stop_trace('1');
> +	change_stack_tracer_status(1);
>  }
>  
>  static void stop_trace(void)
>  {
> -	start_stop_trace('0');
> +	change_stack_tracer_status(0);
>  }
>  
>  static void reset_trace(void)
> @@ -123,8 +166,12 @@ static void read_trace(void)
>  	char *buf = NULL;
>  	size_t n;
>  	int r;
> +	int status;
>  
> -	if (read_proc() == '1')
> +	if (read_proc(&status) <= 0)
> +		die("Invalid stack tracer state");
> +
> +	if (status > 0)
>  		printf("(stack tracer running)\n");
>  	else
>  		printf("(stack tracer not running)\n");
