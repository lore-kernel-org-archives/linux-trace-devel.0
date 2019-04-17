Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5251C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB2A217D7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbfDQOww (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730463AbfDQOww (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:52:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F3921773;
        Wed, 17 Apr 2019 14:52:50 +0000 (UTC)
Date:   Wed, 17 Apr 2019 10:52:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 1/2] trace-cmd: Optimize how pid filters are
 expressed
Message-ID: <20190417105249.37a5e3f5@gandalf.local.home>
In-Reply-To: <20190417135858.GD6118@pauld.bos.csb>
References: <20190417130959.10064-1-kaslevs@vmware.com>
        <20190417130959.10064-2-kaslevs@vmware.com>
        <20190417135858.GD6118@pauld.bos.csb>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Apr 2019 09:58:58 -0400
Phil Auld <pauld@redhat.com> wrote:

> Having seen that and having tried it on a few other machines I'd be more willing to have a
> 
> Tested-by: Phil Auld <pauld@redhat.com>  
> 
> on it, if you want it.

Thanks! I will add it.

-- Steve
