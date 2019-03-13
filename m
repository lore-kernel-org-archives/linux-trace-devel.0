Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60570C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A1D42171F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfCMLYp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:24:45 -0400
Received: from s30320.gliwa.com ([148.251.52.238]:60232 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfCMLYo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 07:24:44 -0400
Received: by mail.gliwa.com (Postfix, from userid 992)
        id C224D341002; Wed, 13 Mar 2019 12:24:42 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25386/Tue Mar 12 09:15:09 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id 7F96A340FD5;
        Wed, 13 Mar 2019 12:24:42 +0100 (CET)
Subject: Re: [PATCH v4 00/46] Libtraceevent MAN pages
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
 <438810f6-6a04-aa9d-a38a-1d0e04c03c5c@gliwa.com>
 <CACqStodFFrxyQR1YD-uL2swMT8nyVSYQJCJzzX=NV2vrRd5sfQ@mail.gmail.com>
 <20190312113506.52ca2568@gandalf.local.home>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <9a489ee4-ca01-93eb-c34d-20bcf0388ded@gliwa.com>
Date:   Wed, 13 Mar 2019 12:24:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190312113506.52ca2568@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On 3/12/19 4:35 PM, Steven Rostedt wrote:
> On Fri, 8 Mar 2019 15:47:14 +0000
> Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
> 
>> Steven could describe it in more details, but we work on common
>> tracing platform - set of libraries, which will expose the tracing
>> functionality, currently available for trace-cmd and kernelshark only,
>> to any application.
> 
> [ Just came back from SCaLE 17x conference ]
> 
> Note, the libtraceevent is currently just a way to parse the data read
> by the Linux kernel trace events. The format files exist in the tracefs
> file system under events/<system>/<event>/format (e.g.
> events/sched/sched_switch/format).
> 
> The library is used by trace-cmd, perf, powertop and mce utils.
> Currently, each has their own copy. We are working on making this into
> a shared library where the code no longer needs to be duplicated.

 
> There's also going to be an effort to create libftrace, that will take
> the functionality of trace-cmd and move it into a library, such that
> any tool can start ftrace tracing, and record data. But that's not going
> to happen until after we finish getting libtraceevent out.
> 
> -- Steve
> 

thank you for this background information, this solves my confusion at the moment.

I currently have my own code that parses the data, based on the event/format,
so I will not replace it immediately, I think that the really valuable replacement
would be the libftrace follow up project.

Ciao,

CLaudio
