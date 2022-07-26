Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B196C00140
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Jul 2022 20:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiGZUHD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 16:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiGZUHC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 16:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB5B31364;
        Tue, 26 Jul 2022 13:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5BE9B8199F;
        Tue, 26 Jul 2022 20:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E844C433D6;
        Tue, 26 Jul 2022 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658866019;
        bh=VfaNb2ida2JYZEEC658IqSjGsRTJppaab8SlNzc2GDQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ACHJgU30rPQkYjaPBGrnjcjPKWss6JSJ5cc1gXR7wDrcq3h17BjAzeNDpaUdtJtw7
         hHRk39n2Wo1rKmEwREGnpwv9uOzgu25equuNmwXiW8BsMTa0bER38OTAFaLvckr8Hn
         3vwayyOdm61b/Pz6CRvRkidQmR7c6MeyZJWjkAaYAgCN9ygGSK2fTNmzKPt8TG9gPw
         aGPZfqJIy7Ez3dSSzbmt0f2TEPjH5S6IDFanxwmD19itMUmqQoLZklQmPYg0pvO6Z9
         Up8Zw8wHVlGG4+UWOqg6kilxBtw+ZInnadUSfJtG3yl1bfFRWZ9TM3qtPZxyMsyj/n
         ovcynGkMG0EhQ==
Message-ID: <0d286c66-2fb7-f91c-8d77-936a311b77de@kernel.org>
Date:   Tue, 26 Jul 2022 22:06:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V7 02/16] rv: Add runtime reactors interface
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
References: <cover.1658778484.git.bristot@kernel.org>
 <516e8767f20f47b185b7dc0dceb1f1d3abb36dce.1658778484.git.bristot@kernel.org>
 <20220726122629.2a99cb6e@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20220726122629.2a99cb6e@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/26/22 18:26, Steven Rostedt wrote:
> On Mon, 25 Jul 2022 22:11:14 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> +/**
>> + * reactor_cleanup_monitor - cleanup a monitor reference
>> + * @mdef:       monitor's definition.
>> + */
>> +void reactor_cleanup_monitor(struct rv_monitor_def *mdef)
>> +{
>> +	mdef->rdef->counter--;
>> +}
>> +
> 
> Doesn't this require a lock? Also you might want to add a WARN_ONCE() if it
> goes below zero.

reactor_populate_monitor() and reactor_cleanup_monitor() should be called with
lock taken... adding lockdep check.

oops, I was not actually calling it yet. Not a BUG, as we do not unload reactors,
it was BUG on the way to happen :-)

Adding a WARN_ONCE().

-- Daniel

> 
> -- Steve

