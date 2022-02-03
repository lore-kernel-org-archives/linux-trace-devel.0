Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF19C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Feb 2022 17:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiBCR4E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 12:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiBCR4E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 12:56:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD2C06173D;
        Thu,  3 Feb 2022 09:56:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA47B61857;
        Thu,  3 Feb 2022 17:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6316C340ED;
        Thu,  3 Feb 2022 17:56:01 +0000 (UTC)
Date:   Thu, 3 Feb 2022 12:56:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/8] rtla/osnoise_top: Fix segmentation fault when
 failing to enable -t
Message-ID: <20220203125600.2a7dbfb4@gandalf.local.home>
In-Reply-To: <846b245d-82c4-faa5-1ba3-733ad197d953@kernel.org>
References: <cover.1643033113.git.bristot@kernel.org>
        <3ef9cb911e9b51be55a874cacc847d44bca9877e.1643033113.git.bristot@kernel.org>
        <20220203114126.3ec6b37d@gandalf.local.home>
        <20220203114303.575910f8@gandalf.local.home>
        <846b245d-82c4-faa5-1ba3-733ad197d953@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 3 Feb 2022 18:30:39 +0100
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> [ thinking aloud, is it possible to have multiple Fixes:? well, adding just one
> would also solve the issue, and... we are still in the same release ]

I've added multiple Fixes tags before. So sure.

-- Steve
