Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C3CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Jul 2022 14:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiGNOq4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Jul 2022 10:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbiGNOqx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Jul 2022 10:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D91564E7
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jul 2022 07:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4510B825EB
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jul 2022 14:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2760C34115;
        Thu, 14 Jul 2022 14:46:48 +0000 (UTC)
Date:   Thu, 14 Jul 2022 10:46:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: avoid pointless extra DEP stage
Message-ID: <20220714104647.41c5b853@gandalf.local.home>
In-Reply-To: <20220711205214.20847-1-jengelh@inai.de>
References: <sso89r95-no6o-3p97-582p-n674pn78qsp5@vanv.qr>
        <20220711205214.20847-1-jengelh@inai.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Jul 2022 22:52:14 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> Call the compiler only once per source file.
> Reduces build time from 0.85 to 0.75 seconds for me.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Applied, thanks Jan!

-- Steve
