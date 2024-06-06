Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A61196C63
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688322; cv=none; b=it7CQuM+mWNlR4MNSmdFx3QA7ycVmn3sUncQEOs6Feinzq0NF6Ry+bh/N+CKz5whcfjJtzgGWdwVJMQW4o3BWCTfs8s8EZo6C+rUxsQ8slklDdGFVmpLdQ/qidSMHE5tID1/kp1gA/tvn1xip+mk6VdgjmdvN7zx7LFVfGVU0lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688322; c=relaxed/simple;
	bh=u/XT+upAt/XhCK2A9tHFGo14sFCWtkGrrAjR6Xm0dNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvCkF43L08KZEOolNItYHWS8IMaIAZQhLJ1tD3CRa6SlE+074D4/ykMlbyTdulo272RAwEoEHIScglZwgayMch2+FNZLKsAnMQ/4Cjplq1dFdUCut95lHwChmU76QXjR9IUhH+KiZwp+JM4mGqZf4Z39iX/CEYuUEarPiIU3FyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VxQzFXf5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VxQzFXf5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAAbFqK7A/rR5+429z/wUXmQQGe2oIVPaGz9NoJ6P9I=;
	b=VxQzFXf5ucsS4EFpoSKlgDv2bl2bJjP8eIu/eOre/Fjx13mvdZbaXQ5J+ALioExAFRfGWr
	UjK9ASPdo6emYXT+nYkCi66MIVRe7PJpPylbMuuwzMgIPJV4xwkxTsNxQrtTHZj3NthCh7
	awEh+XJqUt1NtEYqzoB1dpri4DQvC1Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-PXQrbIpGOrajbskwKyMUHQ-1; Thu, 06 Jun 2024 11:38:38 -0400
X-MC-Unique: PXQrbIpGOrajbskwKyMUHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55DE185A588;
	Thu,  6 Jun 2024 15:38:38 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id CD0FB1C14B13;
	Thu,  6 Jun 2024 15:38:36 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:36 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 02/15] libtracefs: prevent memory leak in append_filer()
Date: Thu,  6 Jun 2024 17:38:16 +0200
Message-ID: <20240606153830.2666120-3-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The buffer containing the new filter isn't freed if we encounter an
error after it was allocated. Free tmp in the error path.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-filter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index afe3338..1b1c60e 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -250,12 +250,12 @@ static int append_filter(char **filter, unsigned int *state,
 	case TRACEFS_COMPARE_NE: tmp = append_string(tmp, NULL, " != "); break;
 	case TRACEFS_COMPARE_RE:
 		if (!is_string)
-			goto inval;
+			goto free;
 		tmp = append_string(tmp, NULL, "~");
 		break;
 	default:
 		if (is_string)
-			goto inval;
+			goto free;
 	}
 
 	switch (compare) {
@@ -277,6 +277,8 @@ static int append_filter(char **filter, unsigned int *state,
 	*state = S_COMPARE;
 
 	return 0;
+free:
+	free(tmp);
 inval:
 	errno = EINVAL;
 	return -1;
-- 
2.44.0

