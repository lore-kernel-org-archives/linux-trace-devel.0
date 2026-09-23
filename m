Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193232C8B
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197054; cv=none; b=pS9vKfDle1Qa5EUgZA2gmM4DyKebWRnKVKwXSJ/ToeGDore7WAhxCKAF7Zf2eYFls2A7WwcFCJZw4UGNGEKOQDmg2ZAGXSBjBzH2Fz3ozpM9XZZci5o65z8td1yL2/8OTWxpbDMxzjiq21z6qYsCjcD2guuf5eIXnbffYlN1Mh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197054; c=relaxed/simple;
	bh=8JPrCiWVPu4MorXc8770Bil+NvbdfnEDgCghO8uuTfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeI2b2O4P47+o5JvqT6AQ/5rTmjHaJ479WyS5nalaQ84A+fs2M/9XSc1aEnxrF/n2UsqxQYokC7wh+693SQFc4gKmUdHv99ZVidQ03pPfk6IGVSrZOszr5+5UiHcAKZxusANd9GGR5Cu59bVcp8EYvAjbspptIDq28lZDblWqrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=GvbJsv+9; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="GvbJsv+9"
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5ECC13F5D4
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1790197050;
	bh=mE/BW7OrGvgoMrIowJYsSFwSikbCgKNrPuNRiE7yQyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=GvbJsv+9TXYZESZjQOfcsuHV1m0OCNEkd60cy6I0hKEjNziihLaeiQmyfXTtNPgfI
	 efVvBq45/9v6rny+SKQp271iNHyua2Zgbsxv/0wzxPmcNMMTxJ8D/ps6VKbyVM4n2C
	 YrfB8BJrpgtFHamet1T3eva9TLO3JpyzGvItqhMtSdMWNHDNkv9NuDh8BG4qDt7vBJ
	 7Yn3WUm+aDulOW+fSc5tiZ79Qvq0tLWBJFz+qk4cnI41Srm8K6qlwJinLPygwOfgXy
	 qgcuxubUfF0S9aRnBTVFl80+Ev4YJvp86P4vftCNrntGu1XfcAc7i8420EIR0OVR4X
	 uzbTLnBkniXtC9Y3dw3Xf9/ca+zChC2mi6iHip6RQgOTksptWeevbBotwM8Wn0PJc5
	 b1GoC0I8fpfXga0CcJx0QzNBzMHwp40aOY8QQ/x4P3TJ5MT4qP9WJ2GLfT6FO7FrG2
	 OHSUGjae/m0wNdoHJe372f1pRMxZV9dlzwUu4CrR2auXp4xJ9A8NKqIQgT4oevDKlM
	 XxybmImvMtEYbnrOjPQn+rODtbnejOjb8lejdIU5al58hX8QuZI7JdJk4JJTu5hOV1
	 JUEcuJiosD4wnSPYgJNa0LqqgctivL6SoYyoJjdIKSG+uBOOEiz+xsTr/YOrvjdJJc
	 46Yy8HFKmsMrTs2+wmqx4G1Q=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767b782so10463995e9.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197050; x=1790801850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mE/BW7OrGvgoMrIowJYsSFwSikbCgKNrPuNRiE7yQyI=;
        b=2v+q7ZmvUXNC9cpNyQ4XzQhKCah6xcsCVzksdnJX0mfPfjMgq+rVa1fc8labaFP3xQ
         zgMCYxNEV1R4wJcVPSbM55kdzOfZfNuOhl0ZmqXViLLElA+CmYvTgw7SZFpv/bD2dcRS
         FWPRBimLEizrzy6iD+hJNOB/axlBvbprK5jJkujErncRDLsqk2nanxDGauEkcIH/rCiq
         ydnMsibpLr9GhVbctpB9nQO4FdtQBmnddkuYpGHMM7o3j6cOWmgDopYnwsqVMD9AQASH
         1WRy0KQj9ZQbF6KH7XJT9Q6xzP9Fr1QRhvBsfTQPo0BDim1UYKsa/0I969rzK8Vgh4oQ
         Jppg==
X-Gm-Message-State: AFuF++mRKaKivp8M79pUMCElZSFgV761NxJBTgsgb4YC4ykZ3LH9QYLj
	VQqA1Dkfu4Fi6cTC7fch0EuPUS9oCyIBUMOF/fNYAg9QN5C1OT/Kd2R83E2YcH5zfE0L6SDSlLX
	mxiU7nFB29IUdKfWxgbmQmDhZz25YT+lHx9oK/6CZg6Ou5Xkg5gyEYpHuTD7gWrebneVsoe+PyY
	+4k16VKINveDTqgV2cgnxRpkU=
X-Gm-Gg: AYBFou1ySL/hthnBAddMs152RKoTX5luYtDHrxuut4Xry9xUznEkMqm49lTDDxyHePK
	luBN4+386MSB7AP3BOAVbL5HweksJwH6ZmEQZ5Q3wZ1dYcLzmhUDYaxvFxeGE24qI8I0mywIs8o
	lBwx6w0R5/wMk9omSq5A00GsCOwnTmhRG5Vu353K1NL0zG7a3MYM/KeuWhuZkTa3Q1UQi+bx6vV
	IsKj7hBbNmkNAxAAHiO5v6a/jf3ctxNHdzNG9ZdAmTCgbiIr7jnQEdRQjngMR5FoRacKlbPOI/G
	VXP5YCsalcb39IAyO3jM8E27SiejjIpKdvGmkZTzwsvX03Tx/zm8T2jmuyP3LkAgB9g2nfyiqJC
	JPMctcmH5Co23ve9/IwF5M9sjNjuLx4xqlPstyYcRsjyZ2LHxqusBMIYBsp8quLz3QvegM/yl
X-Received: by 2002:a05:600c:1546:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fe66bdee6mr7882345e9.4.1790197050073;
        Wed, 23 Sep 2026 13:57:30 -0700 (PDT)
X-Received: by 2002:a05:600c:1546:b0:49e:7a00:b9a5 with SMTP id 5b1f17b1804b1-49fe66bdee6mr7882235e9.4.1790197049793;
        Wed, 23 Sep 2026 13:57:29 -0700 (PDT)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c5b646sm35538545e9.4.2026.09.23.13.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 13:57:29 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH v2 2/3] libtracefs: Use LIBTRACEFS_STATIC for utest
Date: Wed, 23 Sep 2026 22:56:31 +0200
Message-ID: <20260923205650.2638166-3-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923205650.2638166-1-benjamin.drung@canonical.com>
References: <20260826163726.1fe4677a@gandalf.local.home>
 <20260923205650.2638166-1-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The top-level Makefile already sets `LIBTRACEFS_STATIC`. To allow
overriding the static libtracefs library using just this variable, use
`LIBTRACEFS_STATIC` in the utest Makefile as well.

Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 utest/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/utest/Makefile b/utest/Makefile
index f10b709..9bd3dea 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -10,9 +10,11 @@ OBJS =
 OBJS += trace-utest.o
 OBJS += tracefs-utest.o
 
+LIBTRACEFS_STATIC ?= $(obj)/lib/libtracefs.a
+
 LIBS += -lcunit				\
 	-ldl				\
-	$(obj)/lib/libtracefs.a
+	$(LIBTRACEFS_STATIC)
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
@@ -21,7 +23,7 @@ $(bdir):
 
 $(OBJS): | $(bdir)
 
-$(bdir)/trace-utest: $(OBJS) $(obj)/lib/libtracefs.a
+$(bdir)/trace-utest: $(OBJS) $(LIBTRACEFS_STATIC)
 	$(Q)$(do_app_build)
 
 $(bdir)/%.o: %.c
-- 
2.53.0

