Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39175 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933741AbeBMIyD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Feb 2018 03:54:03 -0500
Received: by mail-wr0-f194.google.com with SMTP id w77so3319602wrc.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Feb 2018 00:54:02 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH] trace-cmd: virt-server: fix snprintf-related warnings
Date: Tue, 13 Feb 2018 10:54:07 +0200
Message-Id: <20180213085407.10660-1-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently the build of trace-cmd in the virt-server branch produces
warnings like:

- format not a string literal and no format arguments [-Wformat-security]
- ‘%s’ directive output may be truncated writing up to 255 bytes into a
  region of size 233 [-Wformat-truncation=]

Compiler's concerns are reasonable.
In particular, the statement at trace-listen.c:1468:

	snprintf(un_server->sun_path, strlen(file)+1, file);

Contains two bugs:
	- it is dangerous to use a string instead of a format string
	- the 2nd argument should be buffer's size, not the size of the
	  source string.

The first kind of warnings (2 cases) have been fixed by using strncpy()
instead of snprintf() [+ the right buffer size].

The second kind of warnings (1 case) instead, appears because of the
statement:

[trace-listen.c:954]

	snprintf(file_name, NAME_MAX, LIBVIRT_DOMAIN_PATH"%s",
        	 dirent->d_name);

And has been fixed by using a pair of strcpy() + strncat() with the 'size'
argument of strncat() being:

	sizeof(file_name) - strlen(LIBVIRT_DOMAIN_PATH) - 1

NOTE: sizeof(file_name) == NAME_MAX.
Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 trace-listen.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index afe6084..744c6fb 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -954,8 +954,12 @@ static char *get_guest_domain_from_pid_libvirt(int pid)
 	}
 
 	for (dirent = readdir(dir); dirent != NULL; dirent = readdir(dir)) {
-		snprintf(file_name, NAME_MAX, LIBVIRT_DOMAIN_PATH"%s",
-			 dirent->d_name);
+
+		strcpy(file_name, LIBVIRT_DOMAIN_PATH);
+		strncat(file_name,
+			dirent->d_name,
+			sizeof(file_name) - strlen(LIBVIRT_DOMAIN_PATH) - 1);
+
 		file_name_ret = strstr(file_name, ".pid");
 		if (file_name_ret) {
 			fd = open(file_name, O_RDONLY);
@@ -1468,7 +1472,7 @@ static int create_socket(struct sockaddr_un *un_server,
 		return sfd;
 
 	un_server->sun_family = AF_UNIX;
-	snprintf(un_server->sun_path, strlen(file)+1, file);
+	strncpy(un_server->sun_path, file, sizeof(un_server->sun_path) - 1);
 
 	return sfd;
 }
@@ -2301,7 +2305,7 @@ static int set_up_socket(const char *file)
 		pdie("socket");
 
 	un_server.sun_family = AF_UNIX;
-	snprintf(un_server.sun_path, PATH_MAX, file);
+	strncpy(un_server.sun_path, file, sizeof(un_server.sun_path) - 1);
 
 	if (bind(sfd, (struct sockaddr *)&un_server, slen) < 0)
 		pdie("bind");
-- 
2.14.1
