Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AADE4A2E3E
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jun 2026 08:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649757; cv=none; b=UUBM40oMmERo5IeObBf4YOsKiKXtJJf1JliSQWAQehlVZN6GY3CH0AHRuyGVr6Mvlk+eF6Y6p+GC7n/rMlDplmPQaqlNN6R3H7otPLrRMgYfQgT/H6sF+2RGwZ2o6nY+C+KVtk0/0QG4GruruecOrNQVox2AGxy4Fmib3uzvVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649757; c=relaxed/simple;
	bh=X0vBH4ACaUGl17kwbymaIz0JhMZfiOQvmpCQg2SpZbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ME+Q8JGk/CwkxpVdU21KJ/3zHZMeDWaGrkYu4IsNnq9jkEFP0Uyauu3hIhjd0jjvUlOCjDhrpwLoB3q+Z066gm0MpRHIreRecnc7efX49Q/Mya3zQckfZ3edx7JL8Ay9OkbjOcvb1Ewmuk7mC9zYp+gSo6sgYW9EbkAZqTD96SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=posteo.de; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 61B4D240106
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jun 2026 10:55:45 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4gWwJH2BmRz6v0K;
	Fri,  5 Jun 2026 10:55:43 +0200 (CEST)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: benjamin.drung@canonical.com,
	Adrien Nader <adrien.nader@canonical.com>
Subject: [PATCH] libtracefs utest: Only use online CPUs during tests
Date: Fri, 05 Jun 2026 08:55:43 +0000
Message-ID: <20260605085448.2052357-1-benjamin.drung@canonical.com>
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

