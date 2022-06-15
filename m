Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C48C43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 22:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357104AbiFOWxg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 18:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356170AbiFOWxY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 18:53:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046CD222A2
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 15:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E1EEB82182
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 22:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47BC3411A;
        Wed, 15 Jun 2022 22:52:58 +0000 (UTC)
Date:   Wed, 15 Jun 2022 18:52:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <wagi@monom.org>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] tracefs: Set visibility of parser symbols as 'internal'
Message-ID: <20220615185257.6d35b5ba@gandalf.local.home>
In-Reply-To: <20220607091215.24447-1-wagi@monom.org>
References: <20220607091215.24447-1-wagi@monom.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  7 Jun 2022 11:12:15 +0200
Daniel Wagner <wagi@monom.org> wrote:

> From: Daniel Wagner <dwagner@suse.de>
> 
> Two declarations of an object with 'hidden' linkage refer to
> the same object if they are in the same shared object.
> 
> Internal visibility is like hidden visibility, but with
> additional processor specific semantics. Unless otherwise specified by
> the psABI, GCC defines internal visibility to mean that a function is
> never called from another module.
> 
> It was observed that an 32bit linking against libtracefs failed
> because the parser symbols were missing. As the parser symbols are
> supposed to be used only inside the library, mark them as internal.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---

Applied. Thanks Daniel!

-- Steve
