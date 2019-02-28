Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A63C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 18:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D06218AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 18:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbfB1Sg0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:36:26 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:53202 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731584AbfB1Sg0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 13:36:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83CDC1AC1;
        Thu, 28 Feb 2019 10:36:25 -0800 (PST)
Received: from [0.0.0.0] (e107985-lin.cambridge.arm.com [10.1.194.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 319593F5C1;
        Thu, 28 Feb 2019 10:36:19 -0800 (PST)
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228135343.23kzkilig3bsioov@e107158-lin.cambridge.arm.com>
 <20190228144759.GA156098@google.com>
 <b100f0a2-7966-b6a2-dcd5-ca11abe57ead@arm.com>
 <20190228164801.iahwphx5o2zeks4n@e107158-lin.cambridge.arm.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <df3c8773-bda1-edcf-757b-9dc1c77cc4cf@arm.com>
Date:   Thu, 28 Feb 2019 19:36:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190228164801.iahwphx5o2zeks4n@e107158-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/28/19 5:48 PM, Qais Yousef wrote:
> On 02/28/19 17:04, Dietmar Eggemann wrote:
>> Hi Joel,
>>
>> On 2/28/19 3:47 PM, Joel Fernandes wrote:
>>> On Thu, Feb 28, 2019 at 01:53:43PM +0000, Qais Yousef wrote:
>>>> Hi Joel
>>>>
>>>> On 02/27/19 14:37, Joel Fernandes (Google) wrote:

[...]

>> The reason for me to stay on v4.20 is that with v5.0-rc8 I don't have ebpf
>> 'raw tracepoint' support any more on my arm64 board. But this issue is not
>> related to your patch though.
> 
> And this is caused by a38d1107f937 (bpf: support raw tracepoints in modules)
> which renamed bpf_find_raw_tracepoint() which bcc-tools relies on to detect if
> raw tracepoints are supported..
> 
> https://github.com/iovisor/bcc/blob/master/src/python/bcc/__init__.py#L860
> 
> Speaking of fragile depedencies :-)
> 
> I guess the check can be extended to check for both symbols - but it'll stay
> fragile. Not sure if they can do better.
> 
> I filed a bug
> 
> https://github.com/iovisor/bcc/issues/2240

This did the trick for me on v5.0-rc8. Thanks, Qais!
