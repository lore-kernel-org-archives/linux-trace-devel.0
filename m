Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BB7C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 16:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB01B60243
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 16:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhHDQiI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 12:38:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57826 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhHDQiI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 12:38:08 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 94CBD20B36E0;
        Wed,  4 Aug 2021 09:37:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 94CBD20B36E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628095075;
        bh=2YYCH5sVeQVNg2cxqvlh699B44Ww3dLJQm5SCuKQ9EI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bULI1CsX+a7fFILht47WQrntDaDTA/w1iGoQzjla2/ae/XKPTjoqk52ev+aObTKVS
         YuxetUmvZCwe7W8k1RmcQUurQ3iGyYoJw1DYoThOvFEWumFnpj7DvXMWHGlcXrj1nP
         FRdlALXIjJIJcjxPr2vIwvDBXdA/WwN5DC93haGY=
Date:   Wed, 4 Aug 2021 09:37:51 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] udiag - User mode to trace_event (ftrace, perf,
 eBPF) ABI
Message-ID: <20210804163751.GA3244@kbox>
References: <20210727193535.10326-1-beaub@linux.microsoft.com>
 <20210803171743.36115d4c@oasis.local.home>
 <20210803225200.GA2792@kbox>
 <20210803201718.5d289c4c@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803201718.5d289c4c@rorschach.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 03, 2021 at 08:17:18PM -0400, Steven Rostedt wrote:
> On Tue, 3 Aug 2021 15:52:00 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > For clarity, would you like a resend with the user mode code in the
> > description or would you like an in-thread example?
> 
> In thread example is fine. I'd just like to understand what exactly you
> plan on doing with it.
> 
> -- Steve
Internally we have single trace_events that actually represent many
events. We do this by having the payload start with an int that the eBPF
programs always probes first to get a sub-event ID. The sub-event ID is
then used to determine the actual payload format. We typically use this
pattern to enable a single eBPF program to turn on a class of events
that require tracing. An example is tracing out all the network related
errors, of which there may be many events all with different payloads.

IE:
struct packeterror {
	int id;
	int packetnumber;
	int errorcode;
};

struct connerror {
	int id;
	int connnumber;
	int ip4;
	int errorcode;
};

Both packeterror and connerror would be output to a trace_event with
a name like ms.net.errors. packeterror might have an id of 0 while
connerror would have an id of 1. eBPF or the trace decoder would check
the first int and do further decoding on the payload (or skip it). udiag
sends user data as an eBPF context struct, so user probing costs are
delayed until the program sees something that warrants it. This limits
system cost when tracing is enabled but only a subset of the events are
wanted.

This pattern makes writing an eBPF program that is revolved around
common data much easier. Internally we have macros that translate to the
page check followed by the write syscall. These macros are also used
post compile to auto-generate eBPF probe statements, etc. to make it
harder for developers to get the code wrong on either side.

Here's a simple example showing the general working order and flow we
use on top of udiag. The payload in this case is very simple (a single
int). Payloads in general can be anything, the kernel side doesn't force
a user to use the sub-event models. It works great for us, but some
other users might not require it or have their ideas.

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <fcntl.h>

#define DIAG_IOC_MAGIC '*'
#define DIAG_IOCSREG _IOW(DIAG_IOC_MAGIC, 0, char*)
#define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char*)

int udiag_init(char **eventpage)
{
	int ret;
	int page_size = sysconf(_SC_PAGESIZE);
	int fd = open("/dev/udiag", O_RDWR);

	if (fd == -1) {
		ret = errno;
		goto out;
	}

	/* Map in single page for event enabled checking */
	char *page = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);

	if (page != MAP_FAILED) {
		*eventpage = page;
		ret = 0;
	} else {
		ret = errno;
	}

	close(fd);

out:
	return ret;
}

int udiag_event_open(char *name, int *eventfd, int *eventindex)
{
	int ret;
	int fd;
	long status;

	fd = open("/dev/udiag", O_RDWR);

	if (fd == -1) {
		ret = errno;
		goto out;
	}

	/* Make data written to this fd log under the named event */
	status = ioctl(fd, DIAG_IOCSREG, name);

	if (status < 0) {
		ret = errno;
		close(fd);
		goto out;
	}

	/* Give caller back an fd for writing to this event */
	*eventfd = fd;

	/* Give caller back the index of the page to check if enabled */
	*eventindex = (int)status;

	ret = 0;

out:
	return ret;
}

int main(int argc, char *argv[])
{
	int err, fd, index, payload;
	char *page;

	err = udiag_init(&page);

	if (err != 0) {
		return err;
	}

	err = udiag_event_open("testevent", &fd, &index);

	if (err != 0) {
		return err;
	}

	payload = 0;

	printf("Press enter to write a testevent\n");
fetch:
	getchar();

	/* Avoid write overhead when nothing is listening */
	if (page[index]) {
		payload++;
		write(fd, &payload, sizeof(payload));
		printf("Logged %d", payload);
	} else {
		printf("Event is not being traced currently, enable via:\n");
		printf("echo 1 > /sys/kernel/debug/tracing/events/udiag/testevent/enable");
	}

	goto fetch;

	return 0;
}

Thanks,
-Beau
