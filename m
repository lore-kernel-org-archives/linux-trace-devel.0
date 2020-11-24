Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDD9C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 15:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C09120715
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 15:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJjTuV53"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbgKXPhd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389277AbgKXPhc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 10:37:32 -0500
Received: from localhost (cpc102334-sgyl38-2-0-cust884.18-2.cable.virginm.net [92.233.91.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6713206D9;
        Tue, 24 Nov 2020 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606232252;
        bh=IFQDOQcne/owwjCkX5+QGdYdd5nPT/w1ifsPEHT2KQs=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=JJjTuV53I47R44w4DYywyIiuphe4JHl4wV0GHV97/c9j1ZXuhJLWNSTvPGGkkqNQk
         TMi1E3rOsg0i6N4KLGa5PdcxRU9EPD/A19d8ds7m04ubJAfPeN+m+gNHFQmvET/HJO
         sU1gPyOXna59QIT1TD3ctSrwAFx3hMKAiOW6gES4=
Date:   Tue, 24 Nov 2020 15:37:09 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Philippe Duplessis-Guindon <pduplessis@efficios.com>,
        linux-trace-devel@vger.kernel.org
Cc:     mathieu.desnoyers@efficios.com,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201124135730.9185-1-pduplessis@efficios.com>
References: <20201124135730.9185-1-pduplessis@efficios.com>
Subject: Re: [RFC PATCH v2] tracing: Remove duplicate `type` field from regmap `regcache_sync` trace event
Message-Id: <160623222905.5095.18294249015305684225.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 24 Nov 2020 08:57:30 -0500, Philippe Duplessis-Guindon wrote:
> I have an error saying that `regcache_sync` has 2 fields named `type`
> while using libtraceevent.
> 
> Erase the `int field` type, which is not assigned. This field is
> introduced by mistake and this commit removes it.
> 
> Fixes commit 593600890110c ("regmap: Add the regcache_sync trace event")

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next

Thanks!

[1/1] regmap: Remove duplicate `type` field from regmap `regcache_sync` trace event
      commit: e6e9354b58307c120afbdc2719a6093638c37446

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
