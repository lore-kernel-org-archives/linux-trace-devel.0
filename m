Return-Path: <SRS0=sqOa=W7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F252C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Sep 2019 10:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29E0B2339D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Sep 2019 10:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfIDK34 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 06:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfIDK34 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 06:29:56 -0400
Received: from oasis.local.home (bl11-233-114.dsl.telepac.pt [85.244.233.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E7122CF7;
        Wed,  4 Sep 2019 10:29:54 +0000 (UTC)
Date:   Wed, 4 Sep 2019 06:29:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Uhanov, Kirill" <kirill.uhanov@intel.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH ]trace-recorder.c
Message-ID: <20190904062949.44aa1dd4@oasis.local.home>
In-Reply-To: <E9875C329132824C9E8D827BD6069E125C64C39A@irsmsx110.ger.corp.intel.com>
References: <E9875C329132824C9E8D827BD6069E125C64C39A@irsmsx110.ger.corp.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2 Sep 2019 11:23:18 +0000
"Uhanov, Kirill" <kirill.uhanov@intel.com> wrote:

> Hope is ok if I just add sign-off file.

Hi Kirill,

Could you resend it again starting with "[PATCH]" in the subject, and
not as an attachment. Otherwise your patch doesn't get picked up by
Patchwork and it breaks the flow of adding patches into the git repo.

As I'm traveling, I can't enter your patch into the machine with the
git repo without it being in patchwork. If I was home, I would be able
to do it manually.

Thanks!

-- Steve
