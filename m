Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E813D47A7
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197037; cv=none; b=pgbFSrwqTT0/9QHfslYwARlwhdvWyqSCDSFtRZ+BlGgjxyb2T9E7Rfp7FNims4BSK1j+ByE7+XnWZXnARPM3+ig88De+ZXi263bBdKSJEcfMdpNUyrHaq0l5bHnvNRRlfmlxvlFtPc4EvyqcnrcX0LoEe/opN0Bbpoe3kvs43cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197037; c=relaxed/simple;
	bh=nukKdO1Z+mJgWsCH1/54/UjmfL6dShyLLwvM8NrbPJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErozqRRtcUQY1XRUKZ1Cxp9Pea+UOyhqjxZtfh2p+q9Dd/zcrNqhOYMB59AH8/wYc8SCUylBVGF4CNOckzZ5EUExgkR5T30jdg/z7lZTyP9peXrv+Xm0q4b2r0k9dNwS+uziSk69Zfs9A1AlZbEaK2oA7XJYuKQaaDaz+D3M2YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=C6ua50Y/; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="C6ua50Y/"
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4FF793F57F
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1790197034;
	bh=WujAEfzx3OLHHZR9QqVai3ZXhvnYPHExG/kMGYKeHl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=C6ua50Y/6I0rlKNjCBdIC/YF20XSShK1DIAyyjnZ51lcW0E2jSp/OPqA0dO/jvA0w
	 8IvPsZnwNhGXEJMUNy++1djEmZ14DMNL/Pz+w1cGQdDniCxBQhl0j9/x99rEAlN9GB
	 6lS9U1nXQi42hKJuiJBV4zjo087T6DBwvDtG/aUiijL4J/R6wwVgXEMWPL7VZN7cnm
	 Muc5t4a9XW/ZZpGl0fli55LrmVvrPRWRNywAdFDMijPVvMU/YZ9h2FOsTqtGuXAgW8
	 IbxcerPgkPhhV3QmMeyD/7epVjfNtf6M/vVA8zgyahghMTjRbAg4NSJPv9DM7oAsWt
	 fDjh01Yq22ENgikDEXUSHccNNsML5o/Pn7CEfM6dL2yu8klvUygqXqFPJYnKw7Zz/J
	 4ZUhgcyQjlikm90/4HrxQjXWtKYkemvg7YWQGmJSYlMtUGi2nEo2Sm+p8amYifYkO2
	 5tPSHDNj6QJGZv0dgAZP4d4BvN/8cgmZjwoOA3aiglk1j6yQkEIvAFuK4O6TQF4uoL
	 TKU+c1IB3EX8J/9wgFQ46iGbkSUX68ZxRJeOL7NsOHTRIY3U6rdC9RJ7tqlp5fJaaJ
	 KrdVn443Y3MPgZa002gjS6N8K5zXouQpuNWKzPZ84Ocks/p7BjG0jrmrA2xU2xr7Ro
	 usMTMdOLleQm1DSkj2WzIV5w=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49e635a6002so16991215e9.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:57:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197034; x=1790801834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WujAEfzx3OLHHZR9QqVai3ZXhvnYPHExG/kMGYKeHl0=;
        b=cDiB43Hn0vXkTyyJU/qVoD76IuehVvgfKAvRGzsiJZKmostkcETui4rerYjWiFGVJ4
         L6byXMTCEMMN3F0WTPABx+9nZmd98wwHnRD4LhUEIMny24swBIJaPdrHmHF+Lj/64V6e
         kisishqqcBasDjdlx4l6MOK0G98Hj1vhHkgqezXWEP05bLvWAnL+tGp6z8ghNcP6K4av
         Uj+WmhAhJEh1JwTh8+9o72EFTpqoqDI7RmpGpuldOB7JEUfDeIwskdcWE5WFzwy3Bwq4
         kwy6C7hGQLGs2wePESQ4m9UYO1T9Rlr42fFmUhpCiFjHCYsfi3AaGELT/102g//CX7JC
         1KTg==
X-Gm-Message-State: AFuF++k171tZmrwhiCxBU2Pnfy89Tj4VfH2yTo2hTv7CHBH2Pns+duHT
	kjw4qEiUGy6jkMx0PnTo6sov16qPEtdSAYltvJpc2DF+cSf8yb+RWog2jofpOGapTuJgRx2I0E+
	giXL593jkPP1Lzv28rs7svt6CfnKFhIMf1F3ohL7D/f7S+crlHy3P9cYF3+oMinDL974QDgqfTN
	evlT6Oqppi9WMf1SlfLnpWUmk=
X-Gm-Gg: AYBFou1RPkQnlhDeZjBtCdh6EkjCvgTbUIH9T70YlYEk9AUyK9KfAv+4TWo+nWawoHY
	bcDwN6rB0ylEaGHUTJEIPzjLVooB8qYA18YgqE8sZ6AxP/ar7Z81XdayzX5pQno/vjtwHv7Nemf
	+PGdTF/L52aLMeNRBVmf5cKFiascjHleloktDB2DfkAKGc/KfJ7qvjHqVvAS6SDnePJb0gcyQVQ
	affRUGewk9eDo6hnIB1LYXUPSmWnVjG6lo8jp+i/th/gUHlyVPSkGgOF5v1Io1ZLYPmB4YOucZV
	4mzeQ2x7rK/WasgPDDc9mHHHUH+lCsq+u/M069L1rhjJomdb5uVWAjjRt5i8NWymNX1YsPQdAOr
	A4Og2a08aqJozce0tql34OB2Ao1ZSe3sH193UGTmwJOO5roLU8aWDxHTdehmE1vrIft4laxsu
X-Received: by 2002:a05:600c:8b71:b0:49f:dd6d:79a1 with SMTP id 5b1f17b1804b1-49fe6701ee2mr4899835e9.26.1790197033948;
        Wed, 23 Sep 2026 13:57:13 -0700 (PDT)
X-Received: by 2002:a05:600c:8b71:b0:49f:dd6d:79a1 with SMTP id 5b1f17b1804b1-49fe6701ee2mr4899695e9.26.1790197033679;
        Wed, 23 Sep 2026 13:57:13 -0700 (PDT)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c5b646sm35538545e9.4.2026.09.23.13.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 13:57:13 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH v2 0/3] Ubuntu patches
Date: Wed, 23 Sep 2026 22:56:29 +0200
Message-ID: <20260923205650.2638166-1-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260826163726.1fe4677a@gandalf.local.home>
References: <20260826163726.1fe4677a@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

with quite some delay, here are the requested changes.

v2:
 - Added missing Signed-off-by tags.

Adrien Nader (1):
  libtracefs utest: Only use online CPUs during tests

Benjamin Drung (2):
  libtracefs: Use LIBTRACEFS_STATIC for utest
  libtracefs: Support EXTRA_LIBS for utest

 utest/Makefile        |  7 +++++--
 utest/tracefs-utest.c | 10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.53.0

