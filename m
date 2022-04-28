Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72BDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 16:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiD1Ql0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 12:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbiD1Ql0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 12:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F700ABF42
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 09:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2676620C1
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 16:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D59C385A0;
        Thu, 28 Apr 2022 16:38:09 +0000 (UTC)
Date:   Thu, 28 Apr 2022 12:38:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     vnagare@redhat.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: manpage: Added missing options
Message-ID: <20220428123808.184c5544@gandalf.local.home>
In-Reply-To: <20220426140318.221339-1-vnagare@redhat.com>
References: <20220426140318.221339-1-vnagare@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Apr 2022 19:33:18 +0530
vnagare@redhat.com wrote:

> From: Vaibhav Nagare <vnagare@redhat.com>
> 
> Added multiple missing options which can be found in -h, help page.
> 
> Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
> ---

Applied, thanks Vaibhav!

-- Steve
