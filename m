Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AB6C3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 18:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB1920721
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 18:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgEDStF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 14:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgEDStF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 14:49:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B512E206B9;
        Mon,  4 May 2020 18:49:04 +0000 (UTC)
Date:   Mon, 4 May 2020 14:49:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] kernel-shark: Simplify the search methods in
 class KsTraceViewer
Message-ID: <20200504144903.4f55d0df@gandalf.local.home>
In-Reply-To: <20200504174342.24615-2-y.karadz@gmail.com>
References: <20200504174342.24615-1-y.karadz@gmail.com>
        <20200504174342.24615-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 May 2020 20:43:40 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +++ b/kernel-shark/src/KsTraceViewer.hpp
> @@ -132,8 +132,9 @@ private:
>  
>  	size_t _searchItems();
>  
> -	void _searchItemsMapReduce(int column, const QString &searchText,
> -				   search_condition_func cond);
> +	void _searchItemsST() {_proxyModel.search(&_searchFSM, &_matchList);}
> +
> +	void _searchItemsMT();
>  
>  	void _searchEditText(const QString &);

I'll pull this in as-is, but the above should definitely have comments
stating one is "Single threaded" and the other is  "Multi threaded",
otherwise who would know what they mean?

-- Steve
