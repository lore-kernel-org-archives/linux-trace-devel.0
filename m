Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE6F19D88A
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594998; cv=none; b=g98gyUMW1MtAptd1+dVJzXnC6m+XuUw5AIVOs6b2rPZmimjoPdWWur62Qooc0BDVbDgArgeD/6icUPvQfvRMpjbeBpZDsd/V2mjMh8zMbn6KM75+AuqDBeSnjnHG/0M6hG9kag391KF+/7vAXI8nTm8n/E0WiAyrOIw6nKUqXM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594998; c=relaxed/simple;
	bh=GshlXoLvgs3LqsXB0UcryDH0wG5o1SjC0PRxd9e8o3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2rPkvi05SnQaczqxDOdHyBGMncERc+ZZ+r224ss38r3nPiLhlr+5+77xDlCVxlF5+w3bIq/o5k+776rl7GAS9900+ISDG/5/qIAR9xaDkes28yk5P9vElcNzheoislxwgd4p9FA0B7RZJsJNb5NtchMermVvZRmIp6x5iACAuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFHRP0m/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFHRP0m/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=66vbToxndl15+Gxix4n8gRCK2LAv2WWolhq0YpK+KLk=;
	b=UFHRP0m/5/UEQugyFCek3lElbxtPrkumXsf47fBQ4fsk84IYyWmThLTqiZW0pT89geRdxw
	ZqpmBdk6/sAMd9lCpp/mKQ5MRT+TTuk+xOXBy1v+vWPHvkAh9XYEHPwiOrF9ZpQPdbTVBv
	nTBJSagIE41+2e6UwNhoBneQG1Mat34=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-41KTdpjoN32ymJTRWTzv5A-1; Wed, 05 Jun 2024 09:43:14 -0400
X-MC-Unique: 41KTdpjoN32ymJTRWTzv5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5714C85A588;
	Wed,  5 Jun 2024 13:43:13 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 7DD6F37D0;
	Wed,  5 Jun 2024 13:43:11 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:43:10 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 38/38] trace-cmd lib: prevent a memory leak in tracecmd_tsync_proto_getall()
Date: Wed,  5 Jun 2024 15:40:53 +0200
Message-ID: <20240605134054.2626953-39-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

In tracecmd_tsync_proto_getall() if the allocation plist succeeded but
the allocation of plist->names didn't, the function just returns
without freeing plist. There is already a proper exit path that free
allocated ressource: just use it.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-timesync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 75c27bab..6ee4e643 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -290,7 +290,7 @@ int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const cha
 		goto error;
 	plist->names = calloc(count, sizeof(char *));
 	if (!plist->names)
-		return -1;
+		goto error;
 
 	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next) {
 		if (!(proto->roles & role))
-- 
2.44.0

