Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62899C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Apr 2022 02:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbiDFCts (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457676AbiDEQev (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 12:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE63FC6EC0;
        Tue,  5 Apr 2022 09:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 685B7617D0;
        Tue,  5 Apr 2022 16:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46925C385A1;
        Tue,  5 Apr 2022 16:32:49 +0000 (UTC)
Date:   Tue, 5 Apr 2022 12:32:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        beaub@linux.microsoft.com, mhiramat@kernel.org,
        linux-trace-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, alexei.starovoitov@gmail.com,
        torvalds@linux-foundation.org, michal.lkml@markovi.net,
        ndesaulniers@google.com, linux-kbuild@vger.kernel.org,
        masahiroy@kernel.org
Subject: Re: [PATCH] tracing: Move user_events.h temporarily out of
 include/uapi
Message-ID: <20220405123247.2e98661d@gandalf.local.home>
In-Reply-To: <164917564862.18481.12734568923836492201.git-patchwork-notify@kernel.org>
References: <20220401143903.188384f3@gandalf.local.home>
        <164917564862.18481.12734568923836492201.git-patchwork-notify@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 05 Apr 2022 16:20:48 +0000
patchwork-bot+netdevbpf@kernel.org wrote:

> Hello:
> 
> This patch was applied to netdev/net-next.git (master)
> by Steven Rostedt (Google) <rostedt@goodmis.org>:

It was added to Linus's tree too.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5cfff569cab8bf544bab62c911c5d6efd5af5e05

-- Steve
