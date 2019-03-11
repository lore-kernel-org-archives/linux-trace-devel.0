Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447EAC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10461214AE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfCKWJN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfCKWJN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 18:09:13 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01E452087C;
        Mon, 11 Mar 2019 22:09:06 +0000 (UTC)
Date:   Mon, 11 Mar 2019 18:08:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Slavomir Kaslev <slavomir.kaslev@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] kernel-shark: Define addPlugin method for
 KsPluginManager
Message-ID: <20190311180839.587fc269@oasis.local.home>
In-Reply-To: <3a983bd7-1c93-4bfe-8ead-ff98eefbc6a8@vmware.com>
References: <20190308171405.15266-1-ykaradzhov@vmware.com>
        <20190308171405.15266-2-ykaradzhov@vmware.com>
        <CAE0o1Nv7xkKyFnpYYT4vfpwpQYc_LiNKPuv7aAf7PYUoEUkCTQ@mail.gmail.com>
        <3a983bd7-1c93-4bfe-8ead-ff98eefbc6a8@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Mar 2019 17:39:11 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> > Calling addPlugin() several times in a row will reinitialize all
> > already registered plugins several times and lead to quadratic
> > complexity. This seems wrong to me.
> > 
> > Maybe we should split adding plugins from (re-)initializing them so
> > that one can add several plugins and then have initialized once when
> > they are actually needed to run. Wdyt?
> >   
> 
> Hi Slavi,
> 
> KsPluginManager is a helper class for the GUI. It only does what the GUI 
> is supposed to do. Currently the dialog that allows to load user plugins 
> provides loading only one plugin at a time, so the KsPluginManager 
> provides only this functionality.
> 
> So the questions is: do we want a dialog that loads multiple plugins 
> with one click?

What would be the issue with allowing that?

> 
> On the other hand we do encourage the users to use the KernelShark 
> library for making custom applications. This is the motivation for 
> having the C API, but KsPluginManager it is not part of this API. 
> KsPluginManager operates on top of the API and is intended to be used 
> only by the GUI code.
> 
> Indeed the C API itself separates adding plugins from there initializing.

Just like clicking the plugin dialog, where you select the plugins to
add or remove and hit apply. Couldn't this be the same, or am I missing
something?

-- Steve
