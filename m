Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD78276041
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780062536; cv=none; b=QE1dY/GGcsy2oSM7i3OrEG9yEI4mkC+8TaqgQSvElp3cmXdWHcxc0MyDtHhEA2Cen+tD+kHAv2I/MF6c9IrNF6y7fJn5CjMGm0myVoWmSpUqMCC2O0gWlDa+3u2Clbk3dtNutptNEdzv36ZmmgGUo0asr6bTzWIeLwg2xdUO3rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780062536; c=relaxed/simple;
	bh=rtP0gpjz/fBxFa/+jw2dRM5xXO05DzAZcxm3p8aeg1E=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=TXMPAwD29SembctduFLf5DBZSDoCEzANz/rq/Pn85CDRm22srQ9+/F0lB3tEV1mKEl0BLrYiIcxmBwLcVC2K1zbZt4usBw5k8iMlsMoehkPxZOVta7TniM/T1N7Q+N2+Y8RQjkrD57bpxt95rlJtlTRKiP/2jGXGe2C4fYWLbxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=PSh1JOI7; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="PSh1JOI7"
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1B79A3F641
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1780062526;
	bh=rtP0gpjz/fBxFa/+jw2dRM5xXO05DzAZcxm3p8aeg1E=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version;
	b=PSh1JOI73QwpFWqqrQRUNhi+4NKHhE8v8CHjgBZs/Y+ejNDUYAAQm7N+eGnA4dW5D
	 mnySfErcVG+MmH++wpGfbSnle4jWLHReRRCcD8RiF6B+u+MJ3w62XSKQdQukFEpYFv
	 JZwCU617owQAEPwro5s0HKlJzmJ823gUQvHDtKyFvAk1Lt/I6Wp82udmGNSDSUnIUm
	 vpDdyWMtJPazvAjwIVYd74kwG697pe83eCt2833Q4yyChwEX/7EjhxBEXNFHC+71Md
	 cDJPk5buFPDCPK3F+YVATUWQesXxHaoQ9UmQxt2PDGn32BZ/5n5jtrpHPRoianOkPm
	 8GCPxzuGJdAjSzXpM3muVzh6ewAwW5DdQN0ylDhfzJSjVKi5jj8OXVKzE8Xfu5TR+1
	 GIRrOfOe9HSWxraFIxyIFCPf/DW1Q+45LZc6kkleMb+C8k7Xve6UqVE7oCZCbbKsGQ
	 OhbA+x8wfGduAhdaimdRsD0UIhTHvExmk6OYWP/Mp2SbOxaPy4emezZxpvDcMY53jN
	 9SMZyheTHsk1L+mm5cdkVYP1W611jgOWPIlLKmPrNanHmIFmD6LPApQ3ce947PFCR1
	 vvaYOiNGI7yzZYg5KURmSyikU7lIJaq3/dAG6hoEqwI0q+/sfym8f28KZB8XxkYJUQ
	 pwwI3gDvydc1G7XS/XoQPoGI=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-687157a1739so12194252a12.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 06:48:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780062525; x=1780667325;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rtP0gpjz/fBxFa/+jw2dRM5xXO05DzAZcxm3p8aeg1E=;
        b=HDRLAVZ/boTjGmgO1oIRR4oC5qi6UP6zJ01Z/P+SZwHelbtf/kvLRffrK5mhqZBuOt
         dDXl0SCsejQFvdSKLyINkolA+2D+B90SS9iYazNRq9/mCo0SJRCtyHYEfPS5bwSXmNXF
         IUZsPvbK26FfpY9WEw0XWWPEGdUJklxRViaPHD16rKT13wY1ND1G1jt3f+ABUKsYNStx
         +lBCol5pMo5E5Hnrnk7FZkMXcrnS5ITTn15u1UtxoAkew5t2wZuWg9rKGrBKUPuDo9Fw
         9IamquvMcVHnzF66SQ3lAQ+J2ZQAr0DfyPV9KYJSm1an+rUEk3nQRkIeSQ1OLd1qtkge
         iCPQ==
X-Gm-Message-State: AOJu0Yy2yaj89EwWNiHxPWuxZ0AzzXJb9Dk6fKMW5z/lUXi02QxJzRON
	+HC9q0dIR0t5Ndg2ZQA8Qs4w0C25IrhXc8k2Qye8+mzI2hBdYo/Yrns5tHDex13fJDfyg32DpnT
	S/D2HS790tEGV5l6E4U7LDJ2SuGFmRtr3+NUSq60FBiciTvJl5P1ebrZdZCL/aWCHYouKq0qOx8
	7P38hXdomhxDXCXbumjLbUkLo=
X-Gm-Gg: Acq92OHIu/DyI3vsw/vw/s69S4ulVYGIssueyx640MWB9v3df8ieZLBhoAKXwTPYaZA
	of3Xf7JqGV2wOaioytZYH6fosVy8jh0xjw3osPAiWx9dZQe0e2JoS8hZQTceG7PusXd6NEIef2r
	VSu9Y28c5rWXxxDnv8+Gv5du1YspnK9Hckrn0w6iVZ2lOjUcGvn1KkJ+GlIBF+8Jp0ydnn5KcWA
	iOSFvIWuNVXwhq5Oo4DAfOdWRWQPoW77shNcy034KJB2/l8zidp+T4v5gAJZFtk1p4UipA2LQTf
	Xxf9JeOEPKpRPeZEA94nuK5asDwQu9vV9ZurJd/gcgcHqKIr5KkLdkYyp1+QU5LYh0rBtDtPRmO
	OputBar9oSLOYWsjlW5+oyYoAAGcvl4t1Feku3rmr0igm1WyBFjo9
X-Received: by 2002:a17:907:9288:b0:be2:9d25:3da0 with SMTP id a640c23a62f3a-be9cbdc746dmr180895066b.25.1780062525568;
        Fri, 29 May 2026 06:48:45 -0700 (PDT)
X-Received: by 2002:a17:907:9288:b0:be2:9d25:3da0 with SMTP id a640c23a62f3a-be9cbdc746dmr180893266b.25.1780062525214;
        Fri, 29 May 2026 06:48:45 -0700 (PDT)
Received: from curves.fritz.box ([2001:9e8:842b:9100:6d27:d52c:e00f:8518])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68c1620db76sm617615a12.1.2026.05.29.06.48.44
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 06:48:44 -0700 (PDT)
Message-ID: <711be66181d431d68e4c86bc24e5e394c80466de.camel@canonical.com>
Subject: [PATCH] libtracefs .gitignore: only ignore patches/ at top level
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Date: Fri, 29 May 2026 15:48:44 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The Debian packaging of libtracefs might carry patches in
`debian/patches/` but the `.gitignore` file will ignore this directory.

So tighten the `.gitignore` to only ignore a `patches` directory in the
top-level of the git repository.

Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 .gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 7e61473..125c115 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,7 +6,7 @@ TAGS
 tags
 lib/
 bin/
-patches/
+/patches/
 build_prefix
 build_uninstall
 tfs_version.h
--=20
2.53.0
