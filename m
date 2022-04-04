Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F572C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiDDPIc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbiDDPIc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A202B3AA7A;
        Mon,  4 Apr 2022 08:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FB81615CD;
        Mon,  4 Apr 2022 15:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFEAC340EE;
        Mon,  4 Apr 2022 15:06:34 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:06:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Sebastian Fricke <sebastian.fricke@collabora.com>,
        linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Torsten Duwe <duwe@suse.de>
Subject: Re: Corrupted function tracer in 5.17.0-rc1
Message-ID: <20220404110633.1b246d55@gandalf.local.home>
In-Reply-To: <YksG6LXUCwIZhK8k@FVFF77S0Q05N>
References: <20220404125212.tuby556kara5t56c@basti-XPS-13-9310>
        <20220404102607.5c9cb515@gandalf.local.home>
        <YksG6LXUCwIZhK8k@FVFF77S0Q05N>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Apr 2022 15:55:36 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> From the title, this is v5.17-rc1, which is known broken due to the mcount sort
> issue that was subsequently fixed in commit:

Ah, yes. I was thinking of 5.18-rc1 (which has just been released)

> 
>   4ed308c445a1e3ab ("ftrace: Have architectures opt-in for mcount build time sorting")
> 
> Is it possible to try with the final v5.17? Or at least try with that patch
> cherry-picked?

Right, 5.17-rc1 is known broken. Please try the latest, 5.17 and let us
know if it is still an issue.

Thanks,

-- Steve
