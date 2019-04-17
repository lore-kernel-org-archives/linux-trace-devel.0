Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D47DC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E339821773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfDQOFR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:05:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfDQOFR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:05:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E8157FDE9;
        Wed, 17 Apr 2019 14:05:17 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85C3B5D707;
        Wed, 17 Apr 2019 14:05:16 +0000 (UTC)
Date:   Wed, 17 Apr 2019 10:05:14 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 2/2] trace-cmd: Document record --no-filter option in
 record's man page
Message-ID: <20190417140514.GE6118@pauld.bos.csb>
References: <20190417130959.10064-1-kaslevs@vmware.com>
 <20190417130959.10064-3-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417130959.10064-3-kaslevs@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 17 Apr 2019 14:05:17 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 04:09:59PM +0300 Slavomir Kaslev wrote:
> Add a section about the new --no-filter argument of `trace-cmd record`
> to its man page.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  Documentation/trace-cmd-record.1.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
> index 68afa16..b230aa8 100644
> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -83,6 +83,10 @@ OPTIONS
>  
>      The above are usually safe to use to compare fields.
>  
> +*--no-filter*::
> +    Do not set any event filters, including the default one which ignores events
> +    caused by trace-cmd itself.
> +
>  *-R* 'trigger'::
>      Specify a trigger for the previous event. This must come after a *-e*. 
>      This will add a given trigger to the given event. To only enable the trigger
> -- 
> 2.19.1
> 

Acked-by: Phil Auld <pauld@redhat.com>

and/or

Tested-by: Phil Auld <pauld@redhat.com>




Cheers,
Phil


-- 
