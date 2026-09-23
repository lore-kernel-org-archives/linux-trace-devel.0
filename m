Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F4358375
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197053; cv=none; b=ZHq+2ub56U2Y+hB0cYPFHIu0Vmpvf4a1j8uQKTYMX9ShZKz+uNhfBhAbHQWoiU4vOMgN5CGnYGmfWA/a9vQL5Bt9AQwugYt/wO1LbZjSvGFGCJHTKjQrPYSynWGkFw87XSvabnrXqT1kN9HiE7eX3cK2VItq5y1EFv652/99rbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197053; c=relaxed/simple;
	bh=3JR+ZTnSHKnHnP52//eDrJigATnBHjFRfGxWcz3Mtyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2m6qAqZD4Cfb/hlyolEFsKiOZleJ81dnziYxk+Trch8rrVKXAXW0eFri7pCy7pgN//6UxowpSbpQohkGk6XPwExewyN1pzQ2qiuFfl7NKL8woYKw5QJDiwKcTkXWHQ5x134LUBD83WRNZJZ9lJMI3MBKEyjnFNmDwgmqqYJPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=UYyyndh4; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="UYyyndh4"
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 99ECA3F32D
	for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1790197048;
	bh=YjNWR4abRGMYpRi6/sMj2hi4kmpQOF4F/nqROjvuwB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=UYyyndh43MCRXRNNcDl6H/elLFnAN35Hf6+Hw5oOAmGwCdCbnpXGf1PNTxgAwm7lx
	 YIHwZooQcr7rtsnfR1vk9eCaP5ePtLu4zkctasjD2u/ret1F+UaXrFfI+rmgubxOKV
	 8qRb/dtBmZhnrum128hBW+M7XBrJOpa+gNyYw4m1l4DAYUulCvPj1UjhC0UQPFvdqG
	 Mug3s4htAZiHAGzuq9iVa6BX3OndwDg2hP3Htn6qf39Y9QR3+fi5PRertoxnDpRHgk
	 pyQQGjcfky5W2jWvaB8lYw8jZSPH6cforKU2Nl2Br4Zwj/a7e8g+Gw1ktoH/2CMIjO
	 LXDrtZqDSjHdGSQtg+DMMVonQedVsqezyE3NdK/+9/wAaWsOHhPYLml6Z8FGsO+xoz
	 7kHpn1hKWwhrjQFvgcxpQ54IWjEDXGDkrS4duwG8KkVXQWYwaD2aicsJ0C1HrrBxdN
	 0FFrKDQ50LfkMEt7PZqhliJU2WYT+dixLmATaOHGEeFbI4xemiQxU/8oYUnEbuKK7B
	 1gcogpCWQ8N31TPFw6Q2OOVXS5WD2lMtS0ytGm86znRocy+BwhM1CM63L8k6x9RHtb
	 Hzc9GT4RplNNIXXNlCD0V3oyFeSKBJIzjgVvdqeVrgAhq9kAJta3tzV7NAS2xZz6jM
	 Pw+4Q0yZa5aImK7zv/Cpq2OQ=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495689bfcc8so9407145e9.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197048; x=1790801848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YjNWR4abRGMYpRi6/sMj2hi4kmpQOF4F/nqROjvuwB0=;
        b=GErlgapufq8v0sb0M/EKVr7CxWli96m4U1zXdQ98Vn6fVe2uo3wqzsFVN4/ClDg07k
         T+Lv+Sbpo3fwReJVMnEb7qVSpdkoPMMn3j6sEvX3rAorI3wDgDXyfEvPha0DUXWSU/jA
         hf+27aWkd30rFceGvG8xg+7BWgYFfoMZkguxRyrG6TjkBiMNRTgKXqFwP0P5kZMkX4sQ
         KNUCCPAUZWK/R3HVR9j8H4hjcS3k7vt4f2AQTGMg0tvkAaaPm03q7dy9CAC4lysUtIDD
         UfeXuNaTZ/UVKnnLNNPOh1TgUqpj3XU3ISdQ0c59v4uHDiP66qCpTZZEbIPE3hyb36wM
         VK8A==
X-Gm-Message-State: AFuF++lapSYRZHOaQj4vDs+enInJwr5uytf2pvfl7NdhBss0m1VBfz1X
	4Tx8qqTuJvyblpr4vOQPWFd7IUycDZ0j3skJY2wjt6YPhkTeSPmaibjfkf95nSqgwUmli9oUCcy
	D87N7u18foKmgLUssycMHTcixgJbDECTiD5wFJ2cSUYJ4h7lNDbFUUZrwo0l8HSQz2fKXeM6/4z
	xLTswmmL932qecwSkAAe1DxlE=
X-Gm-Gg: AYBFou3up6xs7sNv2UFSCtUZ9I6vCKGAqx78VQPFvwA7jCJ1NaTZ1tE3wl7w9LjsaHX
	9I3eFJHvsk88AYj3Xc43De2HWlEdQMmVweqAF4WzGQD3YRGGyOOODl4hSf8H65LRSzbck0YBxu5
	NPHXZiWeWOtvF1oEuvkhOr0fggPmloBGvo2GlORUqCXmxNA+49/6ZbLO4TS7OmPGD4WJTQeOgaN
	Ict7me0625zCO3Ok1mgP20tMk5moPBgUMBADh8W5La0WQslCbzfZLtCIaRDsCaiqh50nJRFbIEH
	P85zKepp0XR5VYupN3SHDZDFGU++Tr9ARtRa3PUuYdPuawn6nnz9HQtTXTbPl/othQTWr3zZ0/p
	h1+FsLONbwOBOecRT2RYljLrLwcI3EPPAMqXx3Mgj1s+R57FR5ZtaDv2/fqYnf5aNatJWa0jaIn
	MRTgnF6kU=
X-Received: by 2002:a05:600c:3b1b:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49fe66c8a1emr6410415e9.2.1790197048306;
        Wed, 23 Sep 2026 13:57:28 -0700 (PDT)
X-Received: by 2002:a05:600c:3b1b:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49fe66c8a1emr6410335e9.2.1790197048015;
        Wed, 23 Sep 2026 13:57:28 -0700 (PDT)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c5b646sm35538545e9.4.2026.09.23.13.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 13:57:26 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Adrien Nader <adrien.nader@canonical.com>,
	Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH v2 1/3] libtracefs utest: Only use online CPUs during tests
Date: Wed, 23 Sep 2026 22:56:30 +0200
Message-ID: <20260923205650.2638166-2-benjamin.drung@canonical.com>
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

From: Adrien Nader <adrien.nader@canonical.com>

We cannot do operations over offline cores. Virtual machines can
routinely announce the presence of all of the host's cores and only make
some of them online.

This change assumes that all the online CPUs are continuously numbered
and start at 0. While this is not perfect, it is still an improvement
and might be enough, especially considering this touches tests only.

Signed-off-by: Adrien Nader <adrien.nader@canonical.com>
Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
---
 utest/tracefs-utest.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e3ff215..665c7d9 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -181,7 +181,7 @@ static void save_affinity(void)
 {
 	int cpus;
 
-	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	cpuset_save = CPU_ALLOC(cpus);
 	cpuset = CPU_ALLOC(cpus);
 	cpu_size = CPU_ALLOC_SIZE(cpus);
@@ -216,7 +216,7 @@ static void test_iter_write(struct tracefs_instance *instance)
 	int cpus;
 	int ret;
 
-	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	save_affinity();
 
 	path = tracefs_instance_get_file(instance, "trace_marker");
@@ -243,7 +243,7 @@ static void test_iter_write(struct tracefs_instance *instance)
 
 static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu, bool snapshot)
 {
-	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	cpu_set_t *cpuset = NULL;
 	int cpu_size = 0;
 	int check = 0;
@@ -292,7 +292,7 @@ static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu, b
 
 static void test_instance_iter_raw_events(struct tracefs_instance *instance)
 {
-	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	int ret;
 	int i;
 
@@ -317,7 +317,7 @@ static void test_iter_raw_events(void)
 
 static void test_instance_iter_snapshot_events(struct tracefs_instance *instance)
 {
-	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	int i;
 
 	iter_raw_events_on_cpu(instance, -1, true);
-- 
2.53.0

