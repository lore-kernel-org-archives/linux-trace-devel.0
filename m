Return-Path: <SRS0=CSR1=CX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB478C433E2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Sep 2020 21:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF90215A4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Sep 2020 21:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600118988;
	bh=L629r1L1dGTIIe2QVPIiaULCq2/Fu7o7HXrJ3aHqdJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FhdNNx7pfp/zlw06Lj0yh/m9gLRC5jFNvPFH4FcTQm+libRHZ/gTAS9fIZnZ4YHwd
	 afEnedzFmsCF9vJTvrXCMtuXic5P2gA72VXAbhBqw9jbA+QLp6Yu/KfcayxYIlHkPH
	 1FbgXf4ng2yIPwP22gmq0QMSmmJqDtbICSZr7UwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgINV3s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Sep 2020 17:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgINV3r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 17:29:47 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E81CD20759;
        Mon, 14 Sep 2020 21:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600118987;
        bh=L629r1L1dGTIIe2QVPIiaULCq2/Fu7o7HXrJ3aHqdJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMQUzmEQQ2NJ8dPddZlhthAGQZRboE/RT34I1Rdz8sm9PuCkEuNTZnbEChqpzkYk3
         HzOk4NO2MjPydDiiswTm9iYwJ0unKpWJx7VgvGVkeieO+v5WUuF25i7fo8X8o7U3ND
         LYLPzsaOSIFj8vQn5e39TSJyfyJ+X6iYZxHx5Pdw=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 242F040D3D; Mon, 14 Sep 2020 18:29:45 -0300 (-03)
Date:   Mon, 14 Sep 2020 18:29:45 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-trace-devel@vger.kernel.org
Subject: Re: tep_free_plugin_paths() function in libtraceevent
Message-ID: <20200914212945.GC166601@kernel.org>
References: <e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Fri, Sep 11, 2020 at 03:08:16AM +0100, Ben Hutchings escreveu:
> I noticed that the new function tep_free_plugin_paths() is exported
> from libtraceevent, but is only declared in a private header file.
> 
> If it's meant to be part of the API, it should be declared in a public
> header file.  If not, I think it should be hidden from library users.
> 
> (I think there are other only functions with this issue; this just came
> to my attention because the Debian packaging tools prompted me to
> update the symbol-to-minimum-version mapping.)

Tzvetomir, can you please take a look?

- Arnaldo
