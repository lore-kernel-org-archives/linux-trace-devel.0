Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7005AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 17:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BA4613B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Apr 2021 17:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344578AbhDMRSN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:18:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhDMRSL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 13:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618334270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M6s9zDeT8gTkZ68rPedGR2Yu+AcsSpDjVHkAnNA1XnQ=;
        b=L02TZ62PLbZs/tCOGL9RASOS1EtXC4Gkz+1XlunO8HFq0J9YfoLuLOt9kmrrg0MabAjoim
        LpOuCKFYE57qiD7PJd9ix+C4orayAo9v1yVKYQJYeFZiSyNrW6N6vYyaF+B4V9XQAl8ti5
        nLAfwaPhyss3dqMTjZeSrRN9uDkvW1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-DRx9Ca9OMcuoX-JS6b7WlQ-1; Tue, 13 Apr 2021 13:17:48 -0400
X-MC-Unique: DRx9Ca9OMcuoX-JS6b7WlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD2F364159;
        Tue, 13 Apr 2021 17:17:47 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.195.154])
        by smtp.corp.redhat.com (Postfix) with SMTP id CA3D96062F;
        Tue, 13 Apr 2021 17:17:45 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 13 Apr 2021 19:17:47 +0200 (CEST)
Date:   Tue, 13 Apr 2021 19:17:43 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Mutual debugging of 2 processes can stuck in unkillable stopped
 state
Message-ID: <20210413171741.GA7672@redhat.com>
References: <f2f32ffa-52ad-ff67-19d8-95305a70a6f8@omprussia.ru>
 <20210329164900.GB24849@redhat.com>
 <4124a89e-a62e-0c51-1f46-8409867a626a@omprussia.ru>
 <20210329173848.GC24849@redhat.com>
 <c0131d23-fb09-7622-d51d-30e094d92136@omprussia.ru>
 <f7c84257-70a3-e482-0d3a-8ea95cbc8b62@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c84257-70a3-e482-0d3a-8ea95cbc8b62@omprussia.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Igor,

sorry for delay...

On 04/12, Igor Zhbanov wrote:
>
> Hi Oleg,
>
> So what is the cause of this problem?

The cause is clear. And well known ;) And again, this has almost nothing to do
with the mutual debugging.

The tracee sleeps in ptrace_stop(). You send SIGKILL. This wakes the tracee up,
it dequeues the signal, calls do_exit(), and stops again in PTRACE_EVENT_EXIT.
With SIGKILL in signal->shared_pending. This all looks as if the tracee doesn't
react to SIGKILL.

The only problem is that any change can break something which relies on the
current behaviour :/ I'll write another email on this.

Oleg.

