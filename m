Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2A0196D87
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688344; cv=none; b=OniS1RTsoNhI2DE/JPLdvBVz6QP0YzbQElNSdEnX0MkN5ZLNS9yOO0bKO7YEKIYh48o+z0SuwU2xgkoJIfNGDAe9d0YHwY+dfNBAKQHQLncyb9Uj4i6Ubq2u8whCAk9jMkJs3vQfG+ogf5zFUTI6HZmQAUzAemWZgxirIkX6ZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688344; c=relaxed/simple;
	bh=76EKUrRL1XamIUM8RujyYePYVhatPFCtxjDdQFrzIqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXWswgx7tSVJEgCaLbRDYAW4QBu15jHSCybzZRHVK7VdGz2ca2z9brEAWEIqbODby42EWRBuSDl/dnhgFC7ATl441FI+FV6x/Fhg3UFu5oKH/tKupU8LyO/RezVxMC6/l29xmL+vV7chl6eR8LEuD+70ORwzr+kS5rFiW7kaL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AC4D5V8G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AC4D5V8G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JB+3lrO0vznp2Mfy985Tf1ZPgPBJ+0IFH15r+gGUUVI=;
	b=AC4D5V8Gp2RlGkTwWY1mfTJD5Db1YJZWNtAVADaaQsYBTUZ7qGks7iWqWY2fvRVys4UeTf
	h4VlSJd1ociMOCqg/Zw8+h04tEKujygKZdacU3Cn5+d5H8k77Jyh7vR+UqNHbeyrkQv4wl
	06KzpFDwC2pYi8yl8Jhtc+mo5ioTtM0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-RekuX3xfNe-q_8bHvzb5sw-1; Thu, 06 Jun 2024 11:39:01 -0400
X-MC-Unique: RekuX3xfNe-q_8bHvzb5sw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07D27800074;
	Thu,  6 Jun 2024 15:39:01 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id 8588640C94A8;
	Thu,  6 Jun 2024 15:38:59 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:59 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 09/15] libtracefs: prevent a memory leak in open_cpu_files()
Date: Thu,  6 Jun 2024 17:38:23 +0200
Message-ID: <20240606153830.2666120-10-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

In open_cpu_files(), if realloc() fails the latest allocated tcpu
isn't freed. Rearrange the loop to prevent that.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-events.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index d65837e..88325e1 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -275,9 +275,12 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 			tcpu = tracefs_cpu_snapshot_open(instance, cpu, true);
 		else
 			tcpu = tracefs_cpu_open_mapped(instance, cpu, true);
+		if (!tcpu)
+			goto error;
+
 		tmp = realloc(*all_cpus, (i + 1) * sizeof(*tmp));
 		if (!tmp) {
-			i--;
+			tracefs_cpu_close(tcpu);
 			goto error;
 		}
 
@@ -285,9 +288,6 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 
 		memset(tmp + i, 0, sizeof(*tmp));
 
-		if (!tcpu)
-			goto error;
-
 		tmp[i].tcpu = tcpu;
 		tmp[i].cpu = cpu;
 		i++;
@@ -296,7 +296,7 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 	return 0;
  error:
 	tmp = *all_cpus;
-	for (; i >= 0; i--) {
+	for (i--; i >= 0; i--) {
 		tracefs_cpu_close(tmp[i].tcpu);
 	}
 	free(tmp);
-- 
2.44.0

