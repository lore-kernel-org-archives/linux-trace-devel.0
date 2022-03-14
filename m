Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69CFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 16:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbiCNQC1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiCNQC1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 12:02:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00E6443F9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 09:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48742CE1315
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 16:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D41C340E9;
        Mon, 14 Mar 2022 16:01:13 +0000 (UTC)
Date:   Mon, 14 Mar 2022 12:01:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] trace-cmd library: Fix sparse cpu_data
Message-ID: <20220314120111.5e981ed4@gandalf.local.home>
In-Reply-To: <7aeb8865-3f66-3938-14a6-48b3147455ec@gmail.com>
References: <20220312234032.127108-1-rostedt@goodmis.org>
        <7aeb8865-3f66-3938-14a6-48b3147455ec@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Mar 2022 16:59:13 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Is this fixing the issue with kernelshark crashing when trying to open the new format?

Yes, it was.

-- Steve
