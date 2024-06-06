Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6634D196D8A
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688342; cv=none; b=SvSDXtwj3mfG3CrNh+Atui28QKWEbfL4qFzvpwmjaB5TadpstULJM6VrAEXE+xAo0zBedbF0+aKzvTx6/6sdS8tXqbwgnJsnbxggZUVUB81jvFSF2uv89ouHZzZ+XR+cMuW0dPwCzeFTQt267MbdxaETps12uFb7Wnqjb4MAhDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688342; c=relaxed/simple;
	bh=jcUhe8CYyc2S7hAiJU6etdoZIrGAKYJIAEHT9t+RU4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe54sLe902oJ5suXhAOE8mBQgpsceAis+rknicy9HKiOL9giaChS/r38Zak4aJIw+yGhLZzK/87D2HH6UKbRB0lLn8BaII4Bwzz6IsSHgKHnhTI1PpNFCN/bJIr6PdYQZPDVLiErdDSJEVqBDuns9IXN0JxYQUcnGpTR3pd7Bhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yq5cp2d/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yq5cp2d/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIOYXlopohATiNkq0HhmOG3e2v3g3FQOPNyFDvL4G4Q=;
	b=Yq5cp2d/a+b/Ul30M18OOoWRtuFaq8w/pKdOWzKcxMp7GJI6sw+As0A+5knyoONCGG2bd0
	IoKJrGjmJuSBwvWRkIouRam7XcvGyhWhzbYWg87/t8VmB0o+xfRlfuOEcw8l2CYJEfSgz4
	Yqswpu6YGDajapXi0bp8CORWeIrSd2k=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-bPrcq3K7MQOC9bVBG1UruA-1; Thu,
 06 Jun 2024 11:38:57 -0400
X-MC-Unique: bPrcq3K7MQOC9bVBG1UruA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C87D19772E9;
	Thu,  6 Jun 2024 15:38:56 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 423D73001E9F;
	Thu,  6 Jun 2024 15:38:53 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:52 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 07/15] libtracefs: prevent a memory leak in add_func_str()
Date: Thu,  6 Jun 2024 17:38:21 +0200
Message-ID: <20240606153830.2666120-8-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Free func_list if strdup() fails.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-tools.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 8e7b46d..74cfe91 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -559,8 +559,10 @@ static int add_func_str(struct func_list ***next_func_ptr, const char *func)
 		if (!func_list)
 			return -1;
 		func_list->func = strdup(func);
-		if (!func_list->func)
+		if (!func_list->func) {
+			free(func_list);
 			return -1;
+		}
 		*next_func = func_list;
 		return 0;
 	}
-- 
2.44.0

