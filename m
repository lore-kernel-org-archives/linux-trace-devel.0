Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5980BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 04:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbjADEGq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 23:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjADEGp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 23:06:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EB61582D
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Jan 2023 20:06:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F277B8119A
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 04:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B1EC433D2;
        Wed,  4 Jan 2023 04:06:40 +0000 (UTC)
Date:   Tue, 3 Jan 2023 23:06:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Remove global input buffer
Message-ID: <20230103230636.45239d5b@gandalf.local.home>
In-Reply-To: <20221216102754.257174-1-balbi@kernel.org>
References: <20221216102754.257174-1-balbi@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Dec 2022 12:27:53 +0200
Felipe Balbi <balbi@kernel.org> wrote:

> When using the library with multiple threads, the global input buffer
> pointer gets modified concurrently by each thread. An easy fix for the
> problems that arise is to give each struct tep_handle its own input
> buffer pointer.
> 
>

Applied, thanks Felipe!

-- Steve
