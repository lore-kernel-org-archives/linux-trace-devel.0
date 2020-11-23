Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B5AC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 18:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFEB2075A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 18:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRmm/U8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgKWSLD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:11:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbgKWSLD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 13:11:03 -0500
Received: from localhost (cpc102334-sgyl38-2-0-cust884.18-2.cable.virginm.net [92.233.91.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E8D20717;
        Mon, 23 Nov 2020 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606155062;
        bh=VNR/aQLNMp4zqZ9GzBMffy995RadGsE+quSgHvscqpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRmm/U8CQVWWRqFMdSTBLIlBiDDZsQbGCpCaecuoE4Byqi/F8P8az5Qr0Wm5mfgek
         pIcsNypzmHvMaLwJXnOxc57GNtKerLH3lWUJkyLJ2bom5pMmenzzxErxMP/v1iNxTJ
         fXFHrFAjCpn1xm81ZpkU4EV8DMs4p1A2JjvTOsSQ=
Date:   Mon, 23 Nov 2020 18:10:38 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Philippe Duplessis-Guindon <pduplessis@efficios.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] regmap: remove duplicate `type` field from
 `regcache_sync` trace event
Message-ID: <20201123181038.GN6322@sirena.org.uk>
References: <20201123161519.4643-1-pduplessis@efficios.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yAzUYvkKIfeS0jQX"
Content-Disposition: inline
In-Reply-To: <20201123161519.4643-1-pduplessis@efficios.com>
X-Cookie: Dry clean only.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--yAzUYvkKIfeS0jQX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 23, 2020 at 11:15:19AM -0500, Philippe Duplessis-Guindon wrote:

> 	$ sudo cat /sys/kernel/debug/tracing/events/regmap/regcache_sync/format
> 	name: regcache_sync
> 	ID: 1216
> 	format:

These dumps are very large, don't fit within 80 columns and it's quite
hard to figure out information they are intended to convey so they make
it quite hard to read your commit message.  Please just remove them if
they can't be made clear, I think the text is enough.

> 		field:__data_loc char[] type;	offset:16;	size:4;	signed:1;
> 		field:int type;    offset:20;    size:4;    signed:1;

> Erase the `int field` type, who was not assigned. This field was introduce by mistake and this commit removes it.

Please word wrap your commit message at less than 80 columns.

--yAzUYvkKIfeS0jQX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+7+x4ACgkQJNaLcl1U
h9AAEwf/TUrsISTicYgvsbG5Oc9n2vNLE6N2asuHSqY03Uc/L3RXYTSORkClronK
NoQc9HrdW2sDLlgioQkwOqanAL8EB5Ybx/KCo4dZ5pSaWOopbzCyYIc60NMme1mc
CaLsOg0qMsDtYLyL2HFhNbHzYX1saMZnkKUIS7dPpav4/xBEaD+0GVvcN6vqJKm7
WMJBTucAuame75+TAUR2qAv2mfCQ9g8wu7y3Gvv6uUcwTWhLNvYXA7O+8NaB7BxH
G5zUPdWQyXtyCk7zc0pjWpZTSutGBIneFYUTHaDa0fP1JsYRBui0fWmB7JAd5wAR
K6v+seBHNTPnsf/ytvXDWYAyhCZdeA==
=j3z9
-----END PGP SIGNATURE-----

--yAzUYvkKIfeS0jQX--
