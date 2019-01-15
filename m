Return-Path: <SRS0=27yZ=PX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FDCC43387
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 14:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A835B20675
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 14:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfAOOrC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfAOOrC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 09:47:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5392020657;
        Tue, 15 Jan 2019 14:47:01 +0000 (UTC)
Date:   Tue, 15 Jan 2019 09:46:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH v3 3/6] trace-cmd: Add tracecmd_create_recorder_virt
 function
Message-ID: <20190115094659.43fc8e86@gandalf.local.home>
In-Reply-To: <CAE0o1Ntmr0sxvdMbtdth_vG+aHQbY9vXDKb2Reep595xEasUyw@mail.gmail.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
        <20190114152800.31060-4-kaslevs@vmware.com>
        <20190114171046.6d46da9a@gandalf.local.home>
        <CAE0o1Ntmr0sxvdMbtdth_vG+aHQbY9vXDKb2Reep595xEasUyw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Jan 2019 14:21:11 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> On an unrelated note, the TRACECMD_RECORD_NOSPLICE flag is only needed
> on Linux version <4.20. Do we want to detect if splicing on vsock
> sockets works on startup and use this flag only if necessary?

Yes, sounds reasonable.

-- Steve
