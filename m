Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967D5C54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiIVP0U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiIVP0T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:26:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BBFF0895
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A238D6360E
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E46FC433D6;
        Thu, 22 Sep 2022 15:26:17 +0000 (UTC)
Date:   Thu, 22 Sep 2022 11:27:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zebediah Figura <zfigura@codeweavers.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracecmd extract: Allow using --compression.
Message-ID: <20220922112719.0fda5196@gandalf.local.home>
In-Reply-To: <482fa3dc-6dc0-1b0e-fa5e-a97cc9c131d3@codeweavers.com>
References: <20220901205638.3247090-1-zfigura@codeweavers.com>
        <482fa3dc-6dc0-1b0e-fa5e-a97cc9c131d3@codeweavers.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Sep 2022 10:25:23 -0500
Zebediah Figura <zfigura@codeweavers.com> wrote:

> Signed-off-by: Zeb Figura <zfigura@codeweavers.com>

Thanks!

-- Steve
