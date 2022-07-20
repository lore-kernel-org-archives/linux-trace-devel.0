Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A813FC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jul 2022 17:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbiGTRiQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiGTRiN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 13:38:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7BA6D2C1;
        Wed, 20 Jul 2022 10:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04735B82176;
        Wed, 20 Jul 2022 17:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5685C341C7;
        Wed, 20 Jul 2022 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658338689;
        bh=Yt6GU+e8Sr03z0JsEg+zp/YF2iTy0o8KRPWJe4f3nPc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NqT2PR7nQhs1Fzku2LldppT7NNpCCYa/YsLWfPZTsVov8hAKlPHwaeWeaDOuiyIJl
         yvDvMWLBznAlzBZqJtmMMDdRHn7cyxvhOrxI04FykBcM26h8NX7ZDYs9su12amWLuQ
         yIpjHl0PrEN1rYclD12UAIo0nz9WUcyZ2gegGDwlWzD8eFrQu6xTxc3IYq2O3M+DZe
         fMh7JW6v6GMvaQ6RCSQZQgVm+MD+qEOxHWChnj8Mc+IdjhmUOW5pbRJjaQ41GvUTwt
         xDcJwvBmiKQE0aBE5g8Qea+TZMzPXWc3Mqro2dvVeAfJvRUid8gQIuo8S+RDor1HZm
         /LAHBrLiLxMNg==
Message-ID: <d168f357-e78e-5dc6-09cd-41e6e41e1f4f@kernel.org>
Date:   Wed, 20 Jul 2022 19:37:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V6 02/16] rv: Add runtime reactors interface
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Tao Zhou <tao.zhou@linux.dev>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
References: <cover.1658244826.git.bristot@kernel.org>
 <4b5f93e3186b067073c1692d4c2b50d0b42101d5.1658244826.git.bristot@kernel.org>
 <20220720124133.3cdd2c44@gandalf.local.home>
 <ba11409a-df46-8fad-61a9-256277c588c0@kernel.org>
 <20220720130209.65f501b1@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20220720130209.65f501b1@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/20/22 19:02, Steven Rostedt wrote:
> On Wed, 20 Jul 2022 18:50:39 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> On 7/20/22 18:41, Steven Rostedt wrote:
>>> On Tue, 19 Jul 2022 19:27:07 +0200
>>> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
>>>   
>>>> +/*
>>>> + * reacting_on interface.
>>>> + */
>>>> +static ssize_t reacting_on_read_data(struct file *filp,
>>>> +				     char __user *user_buf,
>>>> +				     size_t count, loff_t *ppos)
>>>> +{
>>>> +	char *buff;
>>>> +
>>>> +	mutex_lock(&rv_interface_lock);
>>>> +	buff = reacting_on ? "1\n" : "0\n";
>>>> +	mutex_unlock(&rv_interface_lock);  
>>> Again, no need for the locks, but perhaps just to keep things sane:
>>>
>>> 	buf = READ_ONCE(reacting_on) ? "1\n" : "0\n";  
>>
>> So, for all files that only read/write a single variable, use READ_ONCE/WRITE_ONCE without
>> locks? (and in all usage of that variable too).
> 
> Only if there's no races.
> 
> That is, taking the locks here provide no benefit over a READ_ONCE().
> 
> If there was some logic that checks if the value is still valid or not,
> then that would be a different story.
> 
> For example:
> 
> static int enable_monitor(struct rv_monitor_def *mdef)
> {
>         int retval;
> 
>         if (!mdef->monitor->enabled) {
>                 retval = mdef->monitor->enable();
>                 if (retval)
>                         return retval;
>         }
> 
>         mdef->monitor->enabled = 1;
> 
>         return 0;
> }
> 
> That has logic that looks to require a lock to protect things from changing
> from underneath.

ack, so the only variable I see we can use READ_ONCE/WRITE_ONCE is the reacting_on...

-- Daniel

> 
> -- Steve

