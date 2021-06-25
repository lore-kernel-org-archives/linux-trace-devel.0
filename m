Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9ECC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 13:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B6161474
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 13:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhFYNss convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 09:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhFYNsq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 09:48:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA47961474;
        Fri, 25 Jun 2021 13:46:25 +0000 (UTC)
Date:   Fri, 25 Jun 2021 09:46:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] libtracefs: Add APIs for data streaming
Message-ID: <20210625094624.6da9a90f@oasis.local.home>
In-Reply-To: <835ff5f9-5fed-0dfb-2d75-dd9158fb63a7@gmail.com>
References: <20210624145101.87233-1-y.karadz@gmail.com>
        <20210624124542.5ca75fe3@oasis.local.home>
        <835ff5f9-5fed-0dfb-2d75-dd9158fb63a7@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Jun 2021 16:17:14 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 24.06.21 г. 19:45, Steven Rostedt wrote:
> > On Thu, 24 Jun 2021 17:51:01 +0300
> > "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> >   
> >> The new APIs can be used to dump the content of "trace_pipe" into a
> >> file or directly to "stdout". The "splice" system call is used to
> >> moves the data without copying. The new functionality is essentially
> >> identical to what 'trace-cmd show -p' does.
> >>
> >> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> >>  
> > 
> > So I did some investigations here, and found that splice() is not
> > guaranteed to work on a terminal output.
> > 
> > To overcome this, I decided to have the print create another pipe, and
> > pass that to the stream code. The if something was read, it would read
> > the pipe.
> > 
> > It required changing the return of the functions to return the amount
> > transferred, so that I can differentiate between "EOF" with nothing
> > read, and something read. Because I couldn't get the pipe to not block
> > on read if there was no content in it. :-/
> > 
> > Anyway, I submitted a v4 with the changes I made, and it appears to
> > work. I haven't tested it that much, so it may still have bugs.
> >   
> 
> Hi Steve,
> 
> I tested v4 of the patch that you submitted and it doesn't work correct in my use case. Also it seems greatly 
> over-complicated to me. Note that when you call tracefs_trace_pipe_stream() inside a loop you will keep opening and 
> closing the "trace_pipe" and the pipe over and over again.

Good point. I could update it to pull out the main work of the splice
logic and have both functions use that, and not have one call the other.

What didn't work with your use case?

> 
> See the example code below. Is this what you are aiming? Also is this guaranteed to always work?

Similar but I'll comment below. Note, the real issue I had in testing
my code was blocking. The read on the pipe would block on EOF even with
a NONBLOCK flag :-/ Which is not what I wanted, and to fix that, it
made the code a bit more complex.

> 
> Thanks!
> Yordan
> 
> 
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <unistd.h>
> #include <signal.h>
> #include <stdbool.h>
> #include <stdio.h>
> #include <errno.h>
> 
> volatile bool keep_going = true;
> 
> static void finish(int sig)
> {
> 	keep_going = false;
> }
> 
> int main(int argc, char **argv)
> {
> 	int splice_flags = SPLICE_F_MORE | SPLICE_F_MOVE;
> 	int brass1[2], brass2[2], fd, ret;
> 	char buf[BUFSIZ];
> 
> 	signal(SIGINT, finish);
> 
> 	fd = open(argv[1], O_RDONLY);
> 	if (fd < 0) {
> 		perror("open");
> 		return 1;
> 	}
> 
> 	if (pipe(brass1) < 0){
> 		perror("pipe A");
> 		return 1;
> 	}
> 
> 	if (pipe(brass2) < 0){
> 		perror("pipe B");
> 		return 1;
> 	}
> 
> 	errno = 0;
> 	while (keep_going) {
> 		ret = splice(fd, NULL,
> 			     brass1[1], NULL,
> 			     BUFSIZ, splice_flags);

The above can block, and if it does, and you hit "ctrl-C" it will
return with ret < 0 and have errno set to EINTR.

> 		if (ret < 0) {

With a Ctrl-C, this would error.

> 			perror("splice A");
> 			return 1;
> 		}
> 		ret = splice(brass1[0], NULL,
> 			     brass2[1], NULL,
> 			     BUFSIZ, splice_flags);
> 		if (ret < 0) {
> 			perror("splice B");
> 			return 1;
> 		}
> 
> 		ret = read(brass2[0], buf, BUFSIZ);

Same here, with the blocking issue.

-- Steve

> 		if (ret < 0) {
> 			perror("read");
> 			return 1;
> 		}
> 
> 		ret = write(STDOUT_FILENO, buf, ret);
> 		if (ret < 0) {
> 			perror("write");
> 			return 1;
> 		}
> 	}
> 
> 	close(fd);
> 	close(brass1[0]);
> 	close(brass1[1]);
> 	close(brass2[0]);
> 	close(brass2[1]);
> 
> 	return 0;
> }
