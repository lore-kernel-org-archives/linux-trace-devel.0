Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2A3C10F03
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 18:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78ED621019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 18:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfCMSmt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 14:42:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35206 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfCMSms (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 14:42:48 -0400
Received: from patrickm (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 14A90335CFB;
        Wed, 13 Mar 2019 18:42:48 +0000 (UTC)
Date:   Wed, 13 Mar 2019 11:42:35 -0700
From:   Patrick McLean <chutzpah@gentoo.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190313114235.7fc6ce3b@patrickm>
In-Reply-To: <20190313152220.22026-2-ykaradzhov@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 17:22:18 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The CMAKE build system of KernelShark performs automated search for
> the trace-cmd libraries, headers and executable before building the
> GUI. The new order of the list of directories to search in is the
> following:
> 
> 1. ${TRACE_CMD}/  ($TRACE_CMD is an environment variable)
> 
> 2. CMAKE_SOURCE_DIR/../
> 
> 3. Platform / system specific locations
> 

For system installs (especially when trace-cmd and trace-cmd are
separate packages), it's nicer to have trace-cmd install a pkgconfig
file. Then the kernelshark can cmake use pkgconfig for getting the
build options to find the headers, libraries, and binaries.

See https://people.freedesktop.org/~dbn/pkg-config-guide.html for
documentation on pkgconfig and pkgconfig files.
