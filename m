Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFF919751B
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688344; cv=none; b=pkpR9XSaoEhbKZq3hPByADC2srLQKzuDtbT+nen5GJVbLpGRM8CtvcWI9i3VOazJbaRDKCq9oCDEzg+MtR6eAqb5Hdpf9jb4SODDXXOFJAAilcJ+hFdAxX3a4duZ9UaCtsNP9rTaZBTEomV3oMUF8crQgGwv7GsmvAv+vcCnW2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688344; c=relaxed/simple;
	bh=/ifqdhaIhlOJEMZltC6M7aVyrEPCDtHUsk5TNSMWouI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEWqCeokSrAJ73jqV0UhD6LgNBTwPG6ZeCH+J6fzVs42c0H0Zl29vQWze9nIjhaohnfscbWtvleT3B4wpG1J1LBGzAm7drQcZLc5YXQlq/n+gwnDoO8wng6mNiVeSlmpRauUPM+fpVa//vmNCuv3s6Uj7AB0SE8VKOWto8zh0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MUJ1wNZS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUJ1wNZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ir6+4hsmkyruWgqCfhI30dqK9/Mhw+EE/HIzqYyct1Q=;
	b=MUJ1wNZSfSrGvBNkZX9wRWDlgoHuELydN6tEUdqACb6lIbVUSTc9AReXA9lRjVdCAUW+FD
	qI07EXefgBN5ga6NsHNqD7oWvkBCGu9cdYSocpCK+0X6luLkOcl/cL5Vx6t6IyKCyY6g9c
	dQVDaHQvKboBFu2Hr+of2rxqGBCRN4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-n-7FdQaVPxWT1XBBRkzDrA-1; Thu, 06 Jun 2024 11:38:59 -0400
X-MC-Unique: n-7FdQaVPxWT1XBBRkzDrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CACED85A588;
	Thu,  6 Jun 2024 15:38:58 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id 53E2BC15E6C;
	Thu,  6 Jun 2024 15:38:57 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:56 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 08/15] libtracefs: prevent a memory leak in tracefs_system_events()
Date: Thu,  6 Jun 2024 17:38:22 +0200
Message-ID: <20240606153830.2666120-9-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

If add_list_string() fails, event isn't freed. Free event before
calling add_list_string();

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-events.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 906dbe8..d65837e 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -919,11 +919,10 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 			free(event);
 			continue;
 		}
+		free(event);
 
 		if (add_list_string(&events, name) < 0)
 			goto out_free;
-
-		free(event);
 	}
 
 	closedir(dir);
-- 
2.44.0

