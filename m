Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5EEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 19:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiBXTkH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 14:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiBXTkF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 14:40:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C792A2763CD
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 11:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63D9861713
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 19:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61735C340E9;
        Thu, 24 Feb 2022 19:39:34 +0000 (UTC)
Date:   Thu, 24 Feb 2022 14:39:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Fix use of uninitialized variable
Message-ID: <20220224143932.60ddcf8b@gandalf.local.home>
In-Reply-To: <20220215120948.4bd0802b@gandalf.local.home>
References: <20220202214646.553872-1-irogers@google.com>
        <20220215120948.4bd0802b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Feb 2022 12:09:48 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> -ENOSOB
> 
>   ;-)

So I applied this patch myself and gave a Reported-by to you, as it
requires the author to have their SOB.

-- Steve
