Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076D1C43334
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 18:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiF1SRG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 14:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiF1SRF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 14:17:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573B41CFC2;
        Tue, 28 Jun 2022 11:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E49FF61ADE;
        Tue, 28 Jun 2022 18:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F39AC3411D;
        Tue, 28 Jun 2022 18:17:01 +0000 (UTC)
Date:   Tue, 28 Jun 2022 14:16:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
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
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V4 06/20] tools/rv: Add dot2c
Message-ID: <20220628141659.309ec0fb@gandalf.local.home>
In-Reply-To: <5b1e664b0c33f4da0430922718adc71a5d58d86c.1655368610.git.bristot@kernel.org>
References: <cover.1655368610.git.bristot@kernel.org>
        <5b1e664b0c33f4da0430922718adc71a5d58d86c.1655368610.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 16 Jun 2022 10:44:48 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> +    def get_minimun_type(self):
> +        min_type="char"
> +
> +        if self.states.__len__() > 255:
> +            min_type="short"
> +
> +        if self.states.__len__() > 65535:
> +            min_type="int"

Should these be "unsigned"? As char goes from -128 <-> 127
and short goes from -32768 <-> 32767

And are you sure you're not going to have more than 2,147,483,647 states ;-)
(or 4,294,967,296 if it's unsigned).

-- Steve

> +
> +        return min_type
> +
