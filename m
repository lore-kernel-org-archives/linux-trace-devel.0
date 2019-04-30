Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB11C43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0BA21743
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfD3WoP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 18:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfD3WoP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 18:44:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D6652087B;
        Tue, 30 Apr 2019 22:44:14 +0000 (UTC)
Date:   Tue, 30 Apr 2019 18:44:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 20/30] tools/lib/traceevent: Man pages get field
 value APIs
Message-ID: <20190430184413.1d70465a@gandalf.local.home>
In-Reply-To: <20190412133811.15878-21-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-21-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:38:01 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +DESCRIPTION
> +-----------
> +These functions can be used to find a field and retrieve its value.
> +
> +The _tep_get_any_field_val()_ function searches in the _record_ for a field
> +with _name_, part of the _event_. If the field is found, its value is stored in
> +_val_. If there is an error and _err_ is not zero, then an error string is
> +written into _s_.
> +
> +The _tep_get_common_field_val()_ function does the same as
> +_tep_get_any_field_val()_, but searches only in the common fields. This works
> +for any event as all events include the common fields.
> +
> +The _tep_get_field_val()_ function does the same as _tep_get_any_field_val()_,
> +but searches only in the event specific fields.
> +
> +The _tep_get_field_raw()_ function searches in the _record_ for a field with
> +_name_, part of the _event_. If the field is found, a pointer to its raw data

"If the field is found, a pointer to where the field exists in the
 record's raw data is returned."

-- Steve

> +is returned. The size of the data is stored in _len_. If there is an error and
> +_err_ is not zero, then an error string is written into _s_.
> +
