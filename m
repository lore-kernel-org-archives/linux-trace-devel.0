Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B98C43334
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jul 2022 13:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiGLNEp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 09:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiGLNEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 09:04:44 -0400
X-Greylist: delayed 307 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 06:04:42 PDT
Received: from mail.nearlyone.de (mail.nearlyone.de [46.163.114.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD5821821
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jul 2022 06:04:42 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4D6395DD2D;
        Tue, 12 Jul 2022 14:59:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
        t=1657630773; h=from:subject:date:message-id:to:cc:mime-version:content-type:
         in-reply-to:references; bh=hNqpOtXpRcsYnq3QvJfc7eBc3bJqo9olx8LgxScjYXo=;
        b=dp74tHAhqXM2kZippzzZWG04LUzXofx0B3gVfbdBuRFUfm3WV0T8WoWYpmj3DrFxgTw466
        DIBoElWSUPmFLXjp53L7+TAoCgjVQSIuTLhD1jTEzKu3Cr3Fskcdd3Im3pT66f+viOOBcr
        GX2g3osLnitITKO0NA9A0nheoigFas4oTEAGnARle6++XaUUeRlKFYvK64tJJvh2nFeXpw
        NHvPTynaVwjqhz6sYag51iYQzYKMrSpLaZh2dtFPncT05FBlFvSkicKp4ZfE2IrYv/V2FW
        /O468kXGIuNEEk+1kwYcScxVGKCJqjg1WmttmgAD10k36K/qEM4hURwDfJEaCw==
Date:   Tue, 12 Jul 2022 14:59:31 +0200
From:   Daniel Wagner <wagi@monom.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] revert: 0de961e74f96 ("libtracefs: Set visibility of
 parser symbols as 'internal'")
Message-ID: <20220712125931.47flimxqmz4ngxau@carbon.lan>
References: <20220711124510.763371d7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711124510.763371d7@gandalf.local.home>
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jul 11, 2022 at 12:45:10PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> With the addition of commit b64dc07ca44c ("libtracefs: Unbreak parallel
> build"), the build works fine without using "internal" variables. We can
> revert that commit.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> 
> [ Daniel, can you test to make sure this is true. Thanks ]

I've tested all possible combinations of master -/+ 0de961e74f96
("libtracefs: Set visibility of parser symbols as 'internal'") and -/+
b64dc07ca44c ("libtracefs: Unbreak parallel build"). My patch doesn't do
a thing and Jan's patch fixes the problem.

Tested-by: Daniel Wagner <dwagner@suse.de>
