Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9801CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhLPMgc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbhLPMgb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:36:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F8DC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58373B823F6
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 12:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FBCC36AE3;
        Thu, 16 Dec 2021 12:36:28 +0000 (UTC)
Date:   Thu, 16 Dec 2021 07:36:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org,
        Dario Faggioli <dfaggioli@suse.com>,
        giuseppe.eletto@edu.unito.it
Subject: Re: [RFC PATCH 0/1] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch.
Message-ID: <20211216073626.41d6791e@gandalf.local.home>
In-Reply-To: <9ac9a1af-6829-425a-7943-755decf7c273@gmail.com>
References: <20211216021649.7273-1-hongzhan.chen@intel.com>
        <20211215220327.0daae29e@gandalf.local.home>
        <b4599ebc-7e53-9d95-32ac-448c1cac8a8a@siemens.com>
        <9ac9a1af-6829-425a-7943-755decf7c273@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 16 Dec 2021 14:29:00 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > We were just wondering how to handle potential (we have no concrete case
> > so far) variations of trace points along releases of those "various OSs"
> > best and were therefore also considering maintaining the plugin in
> > lock-step with the Xenomai releases. How does KernelShark manage such cases?
> >   
> 
> I am adding Dario and Giuseppe to the loop, because they may de interested in this work.
> 
> We can take the plugin upstream as long as it does not add any xenomai specific dependencies (headers or libraries).
> In such case you have to guarantee a persistent commitment for co-maintaining it.
> Alternatively, you can maintain the plugin in a stand alone repository. Dario and Giuseppe are doing this.

I believe Jan is asking about this stand alone like scenario. Where the
plugin is actually maintained in the Xenomai repository.

Is there a way to have the KernelShark user config file automatically load a
plugin? That way a user could have the plugins they are interested in (that
are not part of the main repository) automatically loaded every time they
start KernelShark?

-- Steve
