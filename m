Return-Path: <SRS0=2y7b=6Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCE9C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 May 2020 16:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ABB820801
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 May 2020 16:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0SesddC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEJQSW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 May 2020 12:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgEJQSV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 May 2020 12:18:21 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87984C061A0C;
        Sun, 10 May 2020 09:18:21 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x12so5901074qts.9;
        Sun, 10 May 2020 09:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=CCDwBmXaa9BIAQ2zuOaJ1GngjhFRFzM8zE9mn4mKapw=;
        b=N0SesddCH/TSHZU0Arzstfn5pbmtr8zI0DuwZP+16wTEmKDnRweZ/zK8QpEFbnEKsQ
         9YwAiYPkz0JVUiPMwaO72qCcrLH59HiIlSls6+4HvWPV2C/vShdLjE+zus8PhYm+zmr6
         IwYimCg6OAhhgNqw5rIs41cbwV9hw9AHoT6kzU9C5l4qo+yJ04UBoxEa2jTFpaBusmPw
         11pOoCpHqmgaGnZg3mJ/WTVAe1uNdEmAEp1LfeNqQXsxEYZKif2qtvI9MT/znrXzx9vm
         wLYR8VN6q38xXijuanahV5OnsqRtdENy/mqJG2iwkn1BRUug8TD2w+6O0cy77PW0RO4s
         l3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=CCDwBmXaa9BIAQ2zuOaJ1GngjhFRFzM8zE9mn4mKapw=;
        b=ZcubsPBLdiHwBUiQbaD16hf3lSzlyr8bFILmu0EX2btJ1zfXHbdOA877mweZw5MXe+
         rbO5XG2CIKK0Z7U82CH2PoIoqPk7HxeBQNh/jFqFMWypjmV0t9ysxJyizTfL/Zn/J/9M
         zUsIXmkD761K6SwANP21Gc3QGu68TIjTcqMJkTcjFXlKo2r4XO8u4vyT32bvjW8/tgON
         dEtWfmTCQG9wfwWVx0goDQjwjfzA0pAHq5oB9OEdvkqYR/VNasbnlk0njFLzaJUtZ6tB
         7XUscuFARzjadcHbMofS8WVR0WEZd3NCHyh6yVL7Tezc2eGHvd/AJxBn5ubQeKWUugbF
         LAjA==
X-Gm-Message-State: AGi0PuYYIdHsQpeDP4Mg+bzDF3cInFveIX3QW6eJrJAdic8mDbCvDAVX
        p2clCNgZKocsWmtmnrfQ16dwsUF9t4w=
X-Google-Smtp-Source: APiQypIWVHulUPbfG29QekqU8prAAB1vTCUuwZld8aMu1x7lVWdsXWHr5FIAt6vZ2QFMov/q0nmnYQ==
X-Received: by 2002:ac8:66da:: with SMTP id m26mr12251999qtp.342.1589127500684;
        Sun, 10 May 2020 09:18:20 -0700 (PDT)
Received: from [192.168.86.185] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id k138sm2776710qke.55.2020.05.10.09.18.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 May 2020 09:18:20 -0700 (PDT)
Date:   Sun, 10 May 2020 13:18:12 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20200510112336.444906c1@oasis.local.home>
References: <20200510150628.16610-1-changbin.du@gmail.com> <20200510112336.444906c1@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 00/19] perf: ftrace enhancement
To:     Steven Rostedt <rostedt@goodmis.org>,
        Changbin Du <changbin.du@gmail.com>
CC:     Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
From:   Arnaldo Melo <arnaldo.melo@gmail.com>
Message-ID: <3F63D994-4AD6-4EDE-899B-4B5D6B416B6D@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On May 10, 2020 12:23:36 PM GMT-03:00, Steven Rostedt <rostedt@goodmis=2Eo=
rg> wrote:
>On Sun, 10 May 2020 23:06:09 +0800
>Changbin Du <changbin=2Edu@gmail=2Ecom> wrote:
>
>> The perf has basic kernel ftrace support but lack support of most
>tracing
>> options=2E This serias is target to enhance the perf ftrace
>functionality so
>> that we can make full use of kernel ftrace with only perf=2E
>>=20
>> In general, this serias be cataloged into two main changes:
>>   1) Improve usability of existing functions=2E For example, we don't
>need to type
>>      extra option to select the tracer=2E
>>   2) Add new options to support all other ftrace functions=2E
>>=20
>> Here is a glance of all ftrace functions with this serias:
>>   * - improved existing options=2E
>>   + - new added options=2E
>>=20
>> $ sudo perf ftrace -h
>>=20
>>  Usage: perf ftrace [<options>] [<command>]
>>     or: perf ftrace [<options>] -- <command> [<options>]
>>=20
>> *   -a, --all-cpus        system-wide collection from all CPUs
>> +   -b, --buffer-size <n>
>>                           size of per cpu buffer in kb
>>     -C, --cpu <cpu>       list of cpus to monitor
>> +   -d, --delay <n>       Wait <n> ms before tracing
>>     -D, --graph-depth <n>
>>                           Max depth for function graph tracer
>> *   -G, --graph-funcs <func>
>>                           Set graph filter on given functions (imply
>to use function_graph tracer)
>>     -g, --nograph-funcs <func>
>>                           Set nograph filter on given functions
>(imply to use function_graph tracer)
>> +   -L, --list-functions  List available functions to filter
>> +   -l, --long-info       Show process names, PIDs, timestamps,
>irq-info if available
>>     -N, --notrace-funcs <func>
>>                           do not trace given functions
>> +   -P, --no-pager        Do not use pager
>>     -p, --pid <pid>       trace on existing process id
>> +   -s, --func-stack-trace
>>                           Show kernel stack trace for function tracer
>> +   -t, --tid <tid>       trace on existing thread id (exclusive to
>--pid)
>>     -T, --trace-funcs <func>
>>                           trace given functions only
>> +   -u, --userstacktrace  Show stacktrace of the current user space
>thread
>>     -v, --verbose         be more verbose
>> +       --funcgraph-tail  Show function tails comment (function_graph
>only)
>> +       --latency-format  displays additional information about the
>latency (function_graph only)
>> +       --nofuncgraph-irqs
>>                           Ignore functions that happen inside
>interrupt (function_graph only)
>> +       --nosleep-time    Measure on-CPU time only (function_graph
>only)
>> +       --trace-children  Trace children processes
>> +       --tracing-thresh <n>
>>                           Only show functions of which the duration
>is greater than <n>=C2=B5s
>>=20
>
>Note, we are working on making more of the trace-cmd functionality into
>libraries=2E See this work here:
>
>https://lore=2Ekernel=2Eorg/r/20191219113502=2E28964-2-tz=2Estoyanov@gmai=
l=2Ecom
>
>Which introduces a libtracefs, that is to handle all the work needed to
>interact with the tracefs directory=2E This will also be useful for perf
>to read the event directory without having to open code that work=2E
>
>I'm all for giving perf the functionality of ftrace, but I would like
>to have it do so with a more generic solution that other tools could
>benefit from as well=2E
>

I think in time things will fall into place, 'perf ftrace' has potential a=
s a way for perf users to have a familiar interface to ftrace, and that I t=
hink it's its raison d'=C3=AAtre, in time well go on finding ways to have c=
ommon code=2E

Tomorrow I'll go over this patch set,

Thanks,

- Arnaldo

>Thanks!
>
>-- Steve

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
