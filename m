Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F4CC7618F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 03:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B3422BF5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 03:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="md5rXrSB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kvrTu4d/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfGZD6d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 23:58:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54235 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfGZD6d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 23:58:33 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 7764F223A9;
        Thu, 25 Jul 2019 23:58:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 25 Jul 2019 23:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=28Xn7cJAoDsi3grtt4Y5DaG72g8
        T+FgSDsrj9k9BnfY=; b=md5rXrSBGXr8UPi3AYOXa850nNVlGwIrlrZ/iRE5RUn
        6N1KA7zGg5PPDwvjo1ROXuPzsVJ7yJiunW98U555AK5heq8HucRuaZzzS2/hHPK7
        RV21FR8mpGNoyHhtY0MqiJac0b8uqmeESjbH30LekqRflYw5eemq2Iira7O0Eza1
        8gL67RHE9lyxVcqREapDgloLhtupJNuITu82Ha8Kr4jt4oXqJpx+fUqM6i/UHA70
        ZT6wel/+39CmS/VORtXL9wBLp87ZA3DYB9PcwC9wOf5hvlkinqpZwz+Gf5PJDaKT
        Jev8g+05wlNF3NttGxBST6x3AeMndpz3LNFzBKC30/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=28Xn7c
        JAoDsi3grtt4Y5DaG72g8T+FgSDsrj9k9BnfY=; b=kvrTu4d/zlB6FJpkdmUf1H
        T1BWaqpuSIHqnfetiasrC5urTjuT4FCjWrzrjojJ0Gd4x3xX2OIIW3uMdB21mQUB
        7ua4vi0cDzyHMsNYCKBcFTF0nks3ax7d5jAqp4aXsIXaHzv9ioA1QMVpuwSVMH5j
        TRqjYjrfk73mc+N4y5IPyDpwAGkDIbSradw3EbnnwdYHX5y29g1t0pOFrBXnuNgc
        d2gxl2FwFfrHeVNbiW5z5snxlIviUlLQYepZ3ScValtCDhtAw+LubYzvWL8Ah0wS
        UE4TwcbjKe9hU743bJZVB/n6Cg0CRjYVWpjvVM5AIvrrGETAtSStamuEFkWp/LFw
        ==
X-ME-Sender: <xms:Zno6XZp7xaRHrE5URTDDwiQnafDt89HMlpOx3ShAhZDMRZ40bVkw4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeefgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuffhomhgrih
    hnpehtrhgrtggvqdgvvhgvnhhtqdhprghrshgvrdgtfienucfkphepieejrdduiedtrddv
    udekrddvfeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrg
    iivghlrdguvgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Zno6XaDmjGZbH63LcdI_38bzirpy-jdFZz69Ln8QM-DPpGQz1dYC3w>
    <xmx:Zno6XSOrHRiBJScaaBnXHPSTqxcAY9IzG416ICJ_zuIienc0cibSaA>
    <xmx:Zno6XYDmAsuw0yNfDF2oImVIC95sBq13tDlnIJd1G42CXxJ9-Ef_gQ>
    <xmx:Z3o6XTah6gSoBgT2jBwmtij-9LTGDc3t_DVAhESTs1tIKVMUk8JYVg>
Received: from intern.anarazel.de (c-67-160-218-237.hsd1.ca.comcast.net [67.160.218.237])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91CE2380075;
        Thu, 25 Jul 2019 23:58:30 -0400 (EDT)
Date:   Thu, 25 Jul 2019 20:58:29 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
References: <20181005122225.522155df@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005122225.522155df@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On 2018-10-05 12:22:25 -0400, Steven Rostedt wrote:
> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
>
> As traceevent is going to be transferred into a proper library,
> its local data should be protected from the library users.
> This patch encapsulates struct tep_handler into a local header,
> not visible outside of the library. It implements also a bunch
> of new APIs, which library users can use to access tep_handler members.

This commit appears to have broken perf script --gen-script /
trace_find_next_event().  As far as I can tell:

@ -192,25 +193,29 @@ struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
>  					       struct tep_event_format *event)
>  {
>  	static int idx;
> +	int events_count;
> +	struct tep_event_format *all_events;
>
> -	if (!pevent || !pevent->events)
> +	all_events = tep_get_first_event(pevent);
> +	events_count = tep_get_events_count(pevent);
> +	if (!pevent || !all_events || events_count < 1)
>  		return NULL;
>
>  	if (!event) {
>  		idx = 0;
> -		return pevent->events[0];
> +		return all_events;
>  	}
>
> -	if (idx < pevent->nr_events && event == pevent->events[idx]) {
> +	if (idx < events_count && event == (all_events + idx)) {
>  		idx++;
> -		if (idx == pevent->nr_events)
> +		if (idx == events_count)
>  			return NULL;
> -		return pevent->events[idx];
> +		return (all_events + idx);
>  	}
>
> -	for (idx = 1; idx < pevent->nr_events; idx++) {
> -		if (event == pevent->events[idx - 1])
> -			return pevent->events[idx];
> +	for (idx = 1; idx < events_count; idx++) {
> +		if (event == (all_events + (idx - 1)))
> +			return (all_events + idx);
>  	}
>  	return NULL;
>  }

Is just plain wrong, as:

> -		return pevent->events[idx];
> +		return (all_events + idx);

that's not a valid conversion. ->events isn't an array of tep_handle,
it's an array of tep_handle* (and even if it were, the previous notation
would have needed to dereference the value to make it comparable). What
this does is look idx behind the individually allocated event. Which is
incorrect.


To reproduce the crash, just generating a trace file with at least two
events suffices:

perf record -e raw_syscalls:sys_enter,raw_syscalls:sys_exit sleep 1

gdb --args perf script -g py

Program received signal SIGSEGV, Segmentation fault.
__strlen_avx2 () at ../sysdeps/x86_64/multiarch/strlen-avx2.S:96
96	../sysdeps/x86_64/multiarch/strlen-avx2.S: No such file or directory.
(gdb) bt
#0  __strlen_avx2 () at ../sysdeps/x86_64/multiarch/strlen-avx2.S:96
#1  0x00007ffff726f9ef in _IO_vfprintf_internal (s=s@entry=0x555555c23970, format=format@entry=0x5555558fed76 "def %s__%s(",
    ap=ap@entry=0x7fffffffb900) at vfprintf.c:1638
#2  0x00007ffff7326536 in ___fprintf_chk (fp=fp@entry=0x555555c23970, flag=flag@entry=1,
    format=format@entry=0x5555558fed76 "def %s__%s(") at fprintf_chk.c:35
#3  0x000055555587065c in fprintf (__fmt=0x5555558fed76 "def %s__%s(", __stream=0x555555c23970)
    at /usr/include/x86_64-linux-gnu/bits/stdio2.h:100
#4  python_generate_script (pevent=0x555555c2e620, outfile=<optimized out>)
    at util/scripting-engines/trace-event-python.c:1651
#5  0x0000555555745762 in cmd_script (argc=<optimized out>, argv=0x7fffffffe4d0) at builtin-script.c:3743
#6  0x000055555579821d in run_builtin (p=0x555555abeb38 <commands+408>, argc=3, argv=0x7fffffffe4d0) at perf.c:303
#7  0x0000555555712b7a in handle_internal_command (argv=0x7fffffffe4d0, argc=3) at perf.c:355
#8  run_argv (argcp=<synthetic pointer>, argv=<synthetic pointer>) at perf.c:399
#9  main (argc=3, argv=0x7fffffffe4d0) at perf.c:521


The fix (in recent kernel versions) appears to just bee to use
tep_get_event(), instead of the old pevent->events[...]. But it appears
to me that
commit 80c5526c8544ae76cba31fb9702ab8accac1f0f3
Author: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Date:   2019-04-01 12:43:12 -0400

    tools lib traceevent: Implement new traceevent APIs for accessing struct tep_handler fields

ommitted adding it to event-parse.h. It appears to be intended as public
API however, given that it got documented in

commit 747e942c3925bb85e2865371664499a98fca83b0
Author: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Date:   2019-05-10 15:56:23 -0400

    tools lib traceevent: Man pages for libtraceevent event get APIs


The following patch fixes this for me. I can polish it up, but I'm
wondering if I'm missing something here?

diff --git i/tools/lib/traceevent/event-parse.h w/tools/lib/traceevent/event-parse.h
index 642f68ab5fb2..7ebc9b5308d4 100644
--- i/tools/lib/traceevent/event-parse.h
+++ w/tools/lib/traceevent/event-parse.h
@@ -517,6 +517,7 @@ int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value);
 
 struct tep_event *tep_get_first_event(struct tep_handle *tep);
+struct tep_event *tep_get_event(struct tep_handle *tep, int index);
 int tep_get_events_count(struct tep_handle *tep);
 struct tep_event *tep_find_event(struct tep_handle *tep, int id);
 
diff --git i/tools/perf/util/trace-event-parse.c w/tools/perf/util/trace-event-parse.c
index 62bc61155dd1..6a035ffd58ac 100644
--- i/tools/perf/util/trace-event-parse.c
+++ w/tools/perf/util/trace-event-parse.c
@@ -179,28 +179,26 @@ struct tep_event *trace_find_next_event(struct tep_handle *pevent,
 {
 	static int idx;
 	int events_count;
-	struct tep_event *all_events;
 
-	all_events = tep_get_first_event(pevent);
 	events_count = tep_get_events_count(pevent);
-	if (!pevent || !all_events || events_count < 1)
+	if (!pevent || events_count < 1)
 		return NULL;
 
 	if (!event) {
 		idx = 0;
-		return all_events;
+		return tep_get_event(pevent, 0);
 	}
 
-	if (idx < events_count && event == (all_events + idx)) {
+	if (idx < events_count && event == tep_get_event(pevent, idx)) {
 		idx++;
 		if (idx == events_count)
 			return NULL;
-		return (all_events + idx);
+		return tep_get_event(pevent, idx);
 	}
 
 	for (idx = 1; idx < events_count; idx++) {
-		if (event == (all_events + (idx - 1)))
-			return (all_events + idx);
+		if (event == tep_get_event(pevent, idx - 1))
+			return tep_get_event(pevent, idx);
 	}
 	return NULL;
 }




Not related to this crash, but it also seems that the whole
trace_find_next_event() API ought to be removed. Back when it was

-struct event *trace_find_next_event(struct event *event)
-{
-       if (!event)
-               return event_list;
-
-       return event->next;
-}

it made some sense, but the changes in

commit aaf045f72335653b24784d6042be8e4aee114403
Author: Steven Rostedt <srostedt@redhat.com>
Date:   2012-04-06 00:47:56 +0200

    perf: Have perf use the new libtraceevent.a library

seem to make the current API somewhat absurd, as evidenced by the
complexity in trace_find_next_event(). I mean even just removing that
function and changing the two callsites to simple for loops with
tep_get_events_count() & tep_get_event() ought to be a lot better.

Greetings,

Andres Freund
