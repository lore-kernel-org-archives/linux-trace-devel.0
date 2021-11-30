Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A53CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 14:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243827AbhK3O6y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 09:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243508AbhK3O4y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 09:56:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08650C061D7D
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 06:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5518DCE1A56
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Nov 2021 14:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A99EC53FCF;
        Tue, 30 Nov 2021 14:50:58 +0000 (UTC)
Date:   Tue, 30 Nov 2021 09:50:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] libtracefs: New API for clearing filters
Message-ID: <20211130095056.2645be28@gandalf.local.home>
In-Reply-To: <20211130143422.127433-1-y.karadz@gmail.com>
References: <20211130143422.127433-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Nov 2021 16:34:21 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This patch applys on tom of the 'New tracefs APIs' patch-set.

Please post a link to the patches that this series applies on top of.
Subject names are not precise (harder to find).

-- Steve
